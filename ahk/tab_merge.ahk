ActionMergeTextureToOutputDir:
	Gui, Submit, NoHide
	luaL_dostring(L,"action_merge_ui_equipment_icons()")
Return

SaveSettings:
	Gui, Submit, NoHide
	luaL_dostring(L,"save_settings()")
Return

BrowseGamedataDir:
	FileSelectFolder, GamedataDir
	GuiControl,,GamedataDir,%GamedataDir%
	Gui, Submit, NoHide
Return

BrowseOutputTextureDir:
	FileSelectFolder, OutputTextureDir
	GuiControl,,OutputTextureDir,%OutputTextureDir%
	Gui, Submit, NoHide
Return

BrowseMergeInputDir1:
	FileSelectFolder, InputMergeDir1
	GuiControl,,InputMergeDir1,%InputMergeDir1%
	Gui, Submit, NoHide
Return 

BrowseMergeInputDir2:
	FileSelectFolder, InputMergeDir2
	GuiControl,,InputMergeDir2,%InputMergeDir2%
	Gui, Submit, NoHide
Return 

BrowseMergeInputDir3:
	FileSelectFolder, InputMergeDir3
	GuiControl,,InputMergeDir3,%InputMergeDir3%
	Gui, Submit, NoHide
Return 

BrowseMergeInputDir4:
	FileSelectFolder, InputMergeDir4
	GuiControl,,InputMergeDir4,%InputMergeDir4%
	Gui, Submit, NoHide
Return 