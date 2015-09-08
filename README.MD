#Open X-Ray Icon Texture Tool
by *Alundaio*

##### Summary:
This tools purpose is to unpack ui_icon_equipment.dds into separate individual icons so that they can 
be manipulated individually or merged more easily. This tool is capable of creating a new sprite sheet
using the unpacked icons and writing the new geometry values (w,h,x,y) into the system configs. It also
allows you to merge up to 4 existing unpacked ui_icon_equipment directories into a single sheet.
Stalker Icon Editor, aka SIE is also included and can be launched from the GUI.

The source is all here It was created using AHK (ANSI 32-bit) and lua, and is completely standalone so no need to have lua or AHK installed. Anyone is welcome to fork and modify it for their own purposes. The launcher.exe should be the latest compilation of launcher.ahk. It's just mainly here for those that do not know how to use AHK.

##### Example Usages:
1. Say you create a mod, such as a weapon mod or an item mod with additional icons. If you want your mod to be mergeable into different mods, it is hell for the person who downloads the mod to merge your icons into their existing ui_icon_equipment.dds. That is where this program comes in. Simply create and package your mod like normal. But then you can unpack the ui_icon_equipment.dds and keep [i]only[/i] the icons you added written in shared.ltx and the individual icons. Then you can redistribute the unpacked icons along side your mod so that the person who is using your mod can merge your icons into theirs. Here is an example with OWR3:
[CoC icons before](http://www.epicstalker.com/uploads/stalker/misc/coc_ui_icon_equipment.png)
[CoC icons after](http://www.epicstalker.com/uploads/stalker/misc/owr_ui_icon_equipment.png)

 This was a single click of a button! And all inv_grid_x, inv_grid_y, inv_grid_width and inv_grid_height were updated automatically in the output gamedata directory! Magic!

 You can get the OWR3 package I've used from the mod section of the CoP subforum, to see how you should set up package to be merged into another project: http://forum.epicstalker.com/viewtopic.php?f=8&p=4682#p4682

2. Another possible use is to simply make more room by repacking your icons. The algorithm sorts by cell size, X-Ray engine class and alphabetically. So there is less likely to be unused space allowing you to fit more icons onto the sheet.


##### Unpacking:
###### How-to:
1. First select an input texture using the browse button. The texture can be in any image format, select the ui_icon_equipment
2. Next, select the system.ltx of the mod that belongs to this ui_icon_equipment. You must have unpacked the gamedata for this to work!
3. Select the output directory. This is where new individual textures (.png) will be created using an alias that resembles the first found section name using the icon. A file named shared.ltx will be created in the main output directory. Here is a list of sections by the alias names. In each section will be vital information used for repacking the icons. 
4. Press the *=>* button and it should start unpacking and display a blue progress bar until it is finished.

###### Options:
 1. *Overwrite* - It will overwrite existing textures in the output directory.
 2. *Upgrade Icon Mode* - This will instead cut textures using *upgr_grid_x*, *upgr_grid_y*, *upgr_grid_width* and *upgr_grid_height* used for the icons in *ui_actor_weapons.dds* and *ui_actor_armors.dds*.

###### Tips:
1. Unpacked icon names don't matter. It is just an *alias*. What matters is that the section in *shared.ltx* matches the texture name. Equipment icons that share the same texture will be listed under the same *alias*. You can add/remove sections manually if you wish.
2. You can also change the *_suggested_x* and *_suggested_y* values. The algorithm will try to prioritize the icon in this location first. If not, it will find the first free space according to it's width and height.
3. If you want to add a new icon for a repack, simply create add your texture to the directory. The name is not important and is only used to link the texture to a section name in *shared.ltx*. Once you create a new section in *shared.ltx* named after the new texture you are able to list new item section. Enter the grid width and height and optionally preferred x and y values.	
4. Unpacking creates a xray_sections.ltx which may be useful for other uses. These are all the valid item sections the script has data-mined from system.ltx.
		
##### Repacking:
###### How-to:
1. Select an input directory. This directory must contain a shared.ltx and your unpacked ui_icon_equipment.
2. Select an output texture directory. This is where a file named new_ui_icon_equipment.png will be saved. You will have to manually convert to .dds with paint.net or similar as DXT5 no mip-maps.
3. Select a canvas size. Vanilla is 1024x2048. If you need a bigger size select 2048x2048. If the repack runs out of room it will tell you to check the error log.
4. Select output gamedata directory. This is used when you enable the overwrite system.ltx option to update the new geometry fields for each section.
	
###### Options:
1. *Draft Mode* - Will generate a mock-up of what the final new_ui_icon_equipment will look like but it will not create the final image.
2. *Overwrite System.ltx* - This will save the new geometry (inv_grid_width, inv_grid_x, etc.) for all the sections listed under the alias name in the shared.ltx. This option also works in Draft Mode, so be careful.
3. *Ignore Suggested Geometry* - This will ignore the _suggested_x and _suggested_y values in the shared.ltx and use a sorting algorithm to place icons by size and by engine class. This should actually be faster.
		
###### Tips:
1. If you added a new icon or simply assign a new item section to an alias in the *shared.ltx* you must remember that the output gamedata must have this new section too so that it can update it's geometry values (w,h,x,y)
2. You might need to adjust upgrade_icon positions manually if they change, through *gamedata\configs\ui\texture_descr\ui_icon_equipment.xml*. However, it is soft-coded in the scripts to try to place them in same *x* and *y* coordinates as the vanilla game.
3. I strongly suggest you backup your *gamedata\configs\* directory before doing a repack or merge even though it is unlikely for this program to ruin your gamedata.

###### Issues:
1. The final output of new_ui_icon_equipment is in .png format because of a quality issue when using ImageMagick to convert the png to dxt5 dds.

		
##### Merge:
###### How-to:
1. This is the same directions as Repacking except you have up to 4 input sources. You must have at least 2 sources.
	
###### Options:
1. Same as Repacking 
		
###### Tips:
1. Priority is important. This is the order in which conflicts are resolved. If source A and source B have the same alias, source A's icon and settings in the shared.ltx will be used.
	
###### Issues:
1. The tool is not perfect. Sometimes you will have to do manual changes to the shared.ltx and rename/add/remove sections and icons to get  a perfect merge. Once you get used to how the process is done this step is also quick. An example is when I merged OWR3 icons with CoC. OWR was missing a quest item section for svu and a ak74u; this created duplicate icons on the sheet. The fix was to simply add these missing sections to owr's shared.ltx for the sections using the icons I wanted them to use.
2. Sometimes it's best just to manually merge by copying the unpacked icons over the specific icons you want to change. 
3. Just like repack, the final output of new_ui_icon_equipment is in .png format because of a quality issue when using ImageMagick to convert the png to dxt5 dds.


##### Credits:
Stalker Icon Editor by *malandrinus*
