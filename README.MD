#Open X-Ray Icon Texture Tool
by *Alundaio*

##### Summary:
This tools purpose is to unpack ui_icon_equipment.dds into separate individual icons so that they can 
be manipulated individually or merged more easily. This tool is capable of creating a new sprite sheet
using the unpacked icons and writing the new geometry values (w,h,x,y) into the system configs. It also
allows you to merge up to 4 existing unpacked ui_icon_equipment directories into a single sheet.
Stalker Icon Editor, aka SIE is also included and can be launched from the GUI.


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
1. Equipment icons that share the same texture will be listed under the same alias. You can add/remove sections.
2. You can also change the suggested_x and suggested_y values. The algorithm will try to prioritize the icon in this location first.
3. If you want to add a new item for a repack, simply create a new directory (The name doesn't matter). Then add a new section in shared.ltx with your new item section and your preferred x and y values.	
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
		
##### Merge:
###### How-to:
1. This is the same directions as Repacking except you have up to 4 input sources. You must have at least 2 sources.
	
###### Options:
1. Same as Repacking 
		
###### Tips:
1. Priority is important. This is the order in which conflicts are resolved. If source A and source B have the same alias, source A's icon and settings in the shared.ltx will be used.
	
###### Issues:
1. This tool isn't perfect. If an identical texture from two different *ui_icon_equipment.dds* come from sections of dissimilar names it's possible you can end up with duplicates on the sheet. You will have to manually fix this yourself. Simply fix this by removing one of the textures and removing it's information from the shared.ltx. Then add the section(s) to the priority 1 *shared.ltx*.
2. Sometimes it's best just to manually merge by copying the unpacked icons over the specific icons you want to change. 
	
##### Credits:
Stalker Icon Editor by *malandrinus*
