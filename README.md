# Aseprite Json Exporter Script

The JsonExporter is a script meant to be used with Aseprite which allows you to quickly export a JSON file containing an Aseprite file's animation data. 
It includes things such as Tags, Frame Lengths, Repeats and Animation Directions.

It is useful for importing animations into a game quickly, especially for characters that use the same animations.

## How to set up the script

Firstly, you will need to set up the script in order to use it in Aseprite. To do so, follow these simple steps:

1. 	Open Aseprite.

2. 	In the navbar menu at the top navigate to File > Scripts > Open Scripts Folder. 

<img width="498" height="430" alt="image" src="https://github.com/user-attachments/assets/b8cdd597-19ed-41ce-8598-b4319ea057e5" />


3. 	Take the _modules folder and the JsonExporter.lua file and move them 
    into the Aseprite scripts folder which you have opened previously.

<img width="799" height="242" alt="image" src="https://github.com/user-attachments/assets/87167273-6fba-4a83-8d0c-5cdf1d6dd26a" />


4. 	In Aseprite, rescan the scripts by pressing File > Scripts > Rescan Scripts Folder.

<img width="493" height="413" alt="image" src="https://github.com/user-attachments/assets/ddbd0da0-1617-4611-891d-cb7a7aded3c7" />

## How to use the script

Awesome! So you have set up the script, but how do we use it?
Well luckily, using the script is pretty simple.

Firstly, you will need to add Tags to your Aseprite animation. Make sure your Tag names are all unique, as the script will NOT work with multiple tags of the same name.
Each Tag will represent one Animation present in the Spritesheet you export. After setting up your tags correctly, you can then use the script to export the json.

If you don't know how to make a Tag on Aseprite, highlight the frames you want in the animation timeline, right click, and select "New Tag".

<img width="998" height="256" alt="image" src="https://github.com/user-attachments/assets/0947cf6d-1c62-43e7-aaa6-b6e700bce073" />

To use the script, go to File > Scripts > JsonExporter. Then it's as simple as choosing the export location and whether or not to merge duplicate frames.

<img width="500" height="412" alt="image" src="https://github.com/user-attachments/assets/010dac99-ca54-4bb6-8b58-2fefd039a739" />

<img width="1918" height="1004" alt="image" src="https://github.com/user-attachments/assets/5afc3db2-9cfa-4294-8540-57d052fa0d52" />

**Json Path:** The path of the exported JSON.

**Merge Duplicate Frames:** Whether the JSON should use the same index for duplicate frames or not. If you choose to merge duplicate frames, make sure to export the sprite sheet with duplicate frames merged as well.
