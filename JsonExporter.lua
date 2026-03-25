--
-- JsonExporter.lua
--
-- Copyright (c) 2020 rxi
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--

local json = dofile("_modules/json.lua")

local spr = app.activeSprite
if not spr then return print('No active sprite') end

local path,title = spr.filename:match("^(.+[/\\])(.-).([^.]*)$")

title = title .. ".json"

local fn = spr.filename
local fpath = app.fs.filePath(fn) -- path of the aseprite file

local jsonData = {}
local deduplicatedFrames = {}

-- json fields
jsonData.animations = {}

-- rounds a number to a decimal
local function round(number, decimals)
    local scale = 10^decimals
    local c = 2^52 + 2^51
    return ((number * scale + c ) - c) / scale
end

-- get a frame's image
local function getFrameImage(frameIdx)
    local image = Image(spr.spec)
    image:drawSprite(spr, frameIdx)
    return image
end

-- get the first frame that resembles the frame in the parameter
local function getFirstEqualFrame(frameIdx)
    local img = getFrameImage(frameIdx)
    for i = 1, #spr.frames do
        local compareImg = getFrameImage(i)
        if img:isEqual(compareImg) then
            return i
        end
    end
    return frameIdx
end

local function buildFrame(frames, frameIdx)
    local frame = {}
    frame.idx = 0
    frame.duration = 0
    local idx = deduplicatedFrames[frameIdx] or frameIdx
    if #frames ~= 0 and frames[#frames][1] == idx then
        frames[#frames][2] = frames[#frames][2] + spr.frames[frameIdx].duration
    else
        frame.idx = idx
        frame.duration = spr.frames[frameIdx].duration
        table.insert(frames,frame)
    end
end

local function checkDuplicateTagsError(tags)
    local tagCounts = {} -- counts the amount of times a tag is present

    -- Count all of the tags
    for _,tag in ipairs(tags) do
        tagCounts[tag.name] = tagCounts[tag.name] and tagCounts[tag.name] + 1 or 1
    end

    -- Check if it contains a duplicate and throw and error
    for k, v in pairs(tagCounts) do
        if v > 1 then
            error("Cannot include the same tag more than once: " .. k .. " tag is present " .. v .. " times.")
        end
    end
end

local pathChanged = false

local function filePathChanged()
    pathChanged = true
end

-- Form Entry Fields

local dlg = Dialog()

-- path of the json file (where the json should be exported)
dlg:file{ id="file_path",
          title="Json Path",
          label="Json Path:",
          filename=title,
          open=false,
          save=true,
          entry=true,
          filetypes={ "json" },
          onchange=filePathChanged
}

dlg:check{ id="merge_duplicates", label="Merge Duplicate Frames", selected=true}

dlg:button{ id="confirm", text="Confirm" }
dlg:button{ id="cancel", text="Cancel" }
dlg:show()


local filePath = ""

if dlg.data.confirm then
    if dlg.data.file_path then
        filePath = dlg.data.file_path
    end

    if filePath == "" then
        error("File path must not be empty.")
    end

    -- merging duplicate frames
    if dlg.data.merge_duplicates then
        local nextIndex = 1
        local seenFrames = {}
    
        for i = 1, #spr.frames do
            local realIdx = getFirstEqualFrame(i)
            if not seenFrames[realIdx] then
                seenFrames[realIdx] = nextIndex
                nextIndex = nextIndex + 1
            end
            deduplicatedFrames[i] = seenFrames[realIdx]
        end
    end

    checkDuplicateTagsError(spr.tags)

    -- goes through tags and adds them to the jsonData
    for _,tag in ipairs(spr.tags) do
        local newTag = {}
        newTag.name = tag.name
        newTag.repeats = tag.repeats
        newTag.frames = {}
        
        if tag.aniDir == AniDir.FORWARD or tag.aniDir == AniDir.PING_PONG then
            for i=tag.fromFrame.frameNumber,tag.toFrame.frameNumber do
                buildFrame(newTag.frames, i)
            end
            if tag.aniDir == AniDir.PING_PONG then
                for i=tag.toFrame.frameNumber - 1,tag.fromFrame.frameNumber + 1,-1 do
                    buildFrame(newTag.frames, i)
                end
            end
        elseif tag.aniDir == AniDir.REVERSE or tag.aniDir == AniDir.PING_PONG_REVERSE then
            for i=tag.toFrame.frameNumber,tag.fromFrame.frameNumber,-1 do
                buildFrame(newTag.frames, i)
            end
            if tag.aniDir == AniDir.PING_PONG_REVERSE then
                for i=tag.fromFrame.frameNumber + 1,tag.toFrame.frameNumber - 1 do
                    buildFrame(newTag.frames, i)
                end
            end
        end
        
        -- reduce all indexes by 1
        for k, v in ipairs(newTag.frames) do
            v.idx = v.idx - 1
        end

        if tag.data ~= "" then
            table.insert(newTag.frames, 1, tonumber(tag.data))
        end

        table.insert(jsonData.animations, newTag)
    end

    local file = json.encode(jsonData)
    local myFilePath = filePath

    if pathChanged == false then
        myFilePath = app.fs.joinPath(fpath, filePath)
    end

    local newFile = io.open(myFilePath, "w")  -- "w" for writing mode
    newFile.write(newFile, file)
    newFile.close(newFile)
end