ActionUnpackTextureToOutputDir1:
	Gui, Submit, NoHide
	luaL_dostring(L,"action_unpack_ui_equipment_icons(1)")
Return

ActionUnpackTextureToOutputDir2:
	Gui, Submit, NoHide
	luaL_dostring(L,"action_unpack_ui_equipment_icons(2)")
Return

; Used by Repack also
SaveSettings1:
	Gui, Submit, NoHide
	luaL_dostring(L,"save_settings(1)")
Return

; Used by Repack also
SaveSettings2:
	Gui, Submit, NoHide
	luaL_dostring(L,"save_settings(2)")
Return

BrowseOutputDir1:
	FileSelectFolder, OutputDir1
	GuiControl,,OutputDir1,%OutputDir1%
	Gui, Submit, NoHide
Return

BrowseOutputDir2:
	FileSelectFolder, OutputDir2
	GuiControl,,OutputDir2,%OutputDir2%
	Gui, Submit, NoHide
Return 

BrowseInputTexture1:
	FileSelectFile, InputTexture1, 3, , Select a texture
	GuiControl,,InputTexture1,%InputTexture1%
	Gui, Submit, NoHide
Return

BrowseInputTexture2:
	FileSelectFile, InputTexture2, 3, , Select a texture
	GuiControl,,InputTexture2,%InputTexture2%
	Gui, Submit, NoHide
Return

BrowseSystemLTX1:
	FileSelectFile, SystemLTX1, 3, , Select input system.ltx
	GuiControl,,SystemLTX1,%SystemLTX1%
	Gui, Submit, NoHide
Return

BrowseSystemLTX2:
	FileSelectFile, SystemLTX2, 3, , Select input system.ltx
	GuiControl,,SystemLTX2,%SystemLTX2%
	Gui, Submit, NoHide
Return

