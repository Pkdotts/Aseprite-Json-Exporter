# Aseprite Json Exporter Script

The JsonExporter is a script meant to be used with Aseprite which allows you to quickly export a JSON file containing an Aseprite file's animation data. 
It includes things such as Tags, Frame Lengths, Repeats and Animation Directions.

It is useful for importing animations into a game quickly, especially for characters that use the same animations.

Firstly, you will need to set up the script in order to use it in Aseprite. To do so, follow these simple steps:

1. 	Open Aseprite.

2. 	In the navbar menu at the top navigate to File > Scripts > Open Scripts Folder. 

3. 	Take the _modules folder and the JsonExporter.lua file and move them 
    into the Aseprite scripts folder which you have opened previously.

4. 	In Aseprite, rescan the scripts by pressing File > Scripts > Rescan Scripts Folder.

Awesome! So you have set up the script, but how do we use it?
Well luckily, using the script is pretty simple.

Firstly, you will need to add Tags to your Aseprite animation. Make sure your Tag names are all unique, as the script will NOT work with multiple tags of the same name.
Each Tag will represent one Animation present in the Spritesheet you export. After setting up your tags correctly, you can then use the script to export the json.

If you don't know how to make a Tag on Aseprite, highlight the frames you want in the animation timeline, right click, and select "New Tag".

To use the script, go to File > Scripts > JsonExporter. Then it's as simple as choosing the export location and whether or not to merge duplicate frames.

If you choose to merge duplicate frames, make sure to export the sprite sheet with duplicate frames merged as well.
