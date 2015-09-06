ActionRepackTextureToOutputDir1:
	Gui, Submit, NoHide
	luaL_dostring(L,"action_repack_ui_equipment_icons(1)")
Return

ActionRepackTextureToOutputDir2:
	Gui, Submit, NoHide
	luaL_dostring(L,"action_repack_ui_equipment_icons(2)")
Return

BrowseGamedataDir1:
	FileSelectFolder, GamedataDir1
	GuiControl,,GamedataDir1,%GamedataDir1%
	Gui, Submit, NoHide
Return

BrowseGamedataDir2:
	FileSelectFolder, GamedataDir2
	GuiControl,,GamedataDir2,%GamedataDir2%
	Gui, Submit, NoHide
Return

BrowseInputDir1:
	FileSelectFolder, InputDir1
	GuiControl,,InputDir1,%InputDir1%
	Gui, Submit, NoHide
Return

BrowseInputDir2:
	FileSelectFolder, InputDir2
	GuiControl,,InputDir2,%InputDir2%
	Gui, Submit, NoHide
Return

BrowseOutputTextureDir1:
	FileSelectFolder, OutputTextureDir1
	GuiControl,,OutputTextureDir1,%OutputTextureDir1%
	Gui, Submit, NoHide
Return

BrowseOutputTextureDir2:
	FileSelectFolder, OutputTextureDir2
	GuiControl,,OutputTextureDir2,%OutputTextureDir2%
	Gui, Submit, NoHide
Return