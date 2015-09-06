-- ; Author: Alundaio

function initialize_gui()
	Gui("Add","Button","gLaunchSIE" .. " x322 w100 h20 y0","Launch SIE") -- Laucnh Stalker Icon Editor
	-- Tabs
	Gui("Add", "Tab2", "vTabName x-8 y-1 w760 h550", "Unpack|Repack|Merge")
	Gui("Tab", "Unpack")
		local y_offset = 25
		for i=1,2 do
			-- GroupBox
			Gui("Add", "GroupBox", "x10 w725 h205 y" .. (15+y_offset), "Project " .. i)
			Gui("Add", "GroupBox", "x22 w300 h70 y" .. (39+y_offset), "Input Texture")
			Gui("Add", "GroupBox", "x422 w300 h70 y" .. (39+y_offset), "Output Directory")
			Gui("Add", "GroupBox", "x22 w300 h70 y" .. (109+y_offset), "System.ltx")
			
			-- Button
			Gui("Add","Button","gActionUnpackTextureToOutputDir" .. i .. "  x322 w100 h30 y" .. (59+y_offset),"=>") -- UNPACK
			Gui("Add","Button","gBrowseOutputDir" .. i .. " x692 w25 h20 y" .. (59+y_offset),"...") -- Browse Output Dir
			Gui("Add","Button","gBrowseInputTexture" .. i .. " x292 w25 h20 y" .. (59+y_offset),"...") -- Browse Input Texture
			Gui("Add","Button","gBrowseSystemLTX" .. i .. " x292 w25 h20 y" .. (129+y_offset),"...") -- Browse System.ltx
			Gui("Add","Button","gSaveSettings" .. i .. " x122 w100 h20 y" .. (190+y_offset),"Save Settings") -- Save Settings
			
			-- Edit
			Gui("Add","Edit","x432 w260 h20 vOutputDir" .. i .. " y" .. (59+y_offset),"") -- Edit Output Dir
			Gui("Add","Edit","x32 w260 h20 vInputTexture" .. i .. " y" .. (59+y_offset),"") -- Edit Input Texture
			Gui("Add","Edit","x32 w260 h20 vSystemLTX" .. i .. " y" .. (129+y_offset),"") -- Edit System.ltx
		
			-- Check
			Gui("Add","CheckBox","x432 w280 h20 vOverwriteCheckbox" .. i .. " y" .. (115+y_offset),"Overwrite Existing")
			
			-- Progress
			Gui("Add","Progress","vUnpackProgress" .. i .. " x322 w100 h20 y" .. (89+y_offset), "0")
			y_offset = y_offset + 270
		end
		
	Gui("Tab", "Repack")
		y_offset = 25
		for i=1,2 do
			-- GroupBox
			Gui("Add", "GroupBox", "x10 w725 h205 y" .. (15+y_offset), "Project " .. i)
			Gui("Add", "GroupBox", "x22 w300 h70 y" .. (39+y_offset), "Input Directory")
			Gui("Add", "GroupBox", "x422 w300 h70 y" .. (39+y_offset), "Output Texture Directory")
			Gui("Add", "GroupBox", "x422 w300 h70 y" .. (109+y_offset), "Output Gamedata Directory")
			
			-- Button
			Gui("Add","Button","gActionRepackTextureToOutputDir" .. i .. "  x322 w100 h30 y" .. (59+y_offset),"=>") -- REPACK
			Gui("Add","Button","gBrowseOutputTextureDir" .. i .. " x692 w25 h20 y" .. (59+y_offset),"...") -- Browse Output Texture Directory
			Gui("Add","Button","gBrowseInputDir" .. i .. " x292 w25 h20 y" .. (59+y_offset),"...") -- Browse Input Directory
			Gui("Add","Button","gBrowseGamedataDir" .. i .. " x692 w25 h20 y" .. (129+y_offset),"...") -- Browse Gamedata Directory
			Gui("Add","Button","gSaveSettings" .. i .. " x532 w100 h20 y" .. (190+y_offset),"Save Settings") -- Save Settings
			
			-- Edit
			Gui("Add","Edit","x32 w260 h20 vInputDir" .. i .. " y" .. (59+y_offset),"") -- Edit Input Directory
			Gui("Add","Edit","x432 w260 h20 vOutputTextureDir" .. i .. " y" .. (59+y_offset),"") -- Edit Output Texture Directory
			Gui("Add","Edit","x432 w260 h20 vGamedataDir" .. i .. " y" .. (129+y_offset),"") -- Edit Gamedata Directory
			
			-- ComboBox
			Gui("Add","ComboBox","Choose1 R3 x432 w100 h20 vCanvasSize" .. i .. " y" .. (80+y_offset),"1024x2048|2048x2048")
			
			-- Check
			Gui("Add","CheckBox","x35 w280 h20 vOverwriteSystemLTX" .. i .. " y" .. (115+y_offset),"Overwrite system.ltx")
			Gui("Add","CheckBox","x35 w280 h20 vIgnoreSuggested" .. i .. " y" .. (135+y_offset),"Ignore suggested geometry")
			Gui("Add","CheckBox","x35 w280 h20 vRoughDraft" .. i .. " y" .. (155+y_offset),"Draft mode")
			
			-- Progress
			Gui("Add","Progress","vRepackProgress" .. i .. " x322 w100 h20 y" .. (89+y_offset), "0")
			y_offset = y_offset + 270
		end
		
	Gui("Tab", "Merge")
		y_offset = 25
		
		-- GroupBox
		Gui("Add", "GroupBox", "x22 w300 h351 y" .. (39+y_offset), "Input Directories")
		Gui("Add", "GroupBox", "x422 w300 h70 y" .. (39+y_offset), "Output Texture Directory")
		Gui("Add", "GroupBox", "x422 w300 h70 y" .. (109+y_offset), "Output Gamedata Directory")
			
		-- Button
		Gui("Add","Button","gActionMergeTextureToOutputDir" .. "  x322 w100 h30 y" .. (59+y_offset),"=>") -- REPACK
		Gui("Add","Button","gBrowseOutputTextureDir" .. " x692 w25 h20 y" .. (59+y_offset),"...") -- Browse Output Texture Directory
		Gui("Add","Button","gBrowseGamedataDir" .. " x692 w25 h20 y" .. (129+y_offset),"...") -- Browse Gamedata Directory
		Gui("Add","Button","gSaveSettings" .. " x532 w100 h20 y" .. (460+y_offset),"Save Settings") -- Save Settings
		
		-- Edit
		Gui("Add","Edit","x432 w260 h20 vOutputTextureDir" .. " y" .. (59+y_offset),"") -- Edit Output Texture Directory
		Gui("Add","Edit","x432 w260 h20 vGamedataDir" .. " y" .. (129+y_offset),"") -- Edit Gamedata Directory
			
		-- Check
		Gui("Add","CheckBox","x432 w280 h20 vOverwriteSystemLTX y" .. (185+y_offset),"Overwrite system.ltx")
		Gui("Add","CheckBox","x432 w280 h20 vIgnoreSuggested y" .. (205+y_offset),"Ignore suggested geometry")
		Gui("Add","CheckBox","x432 w280 h20 vRoughDraft y" .. (225+y_offset),"Draft mode")
			
		-- Progress
		Gui("Add","Progress","vMergeProgress" .. " x322 w100 h20 y" .. (89+y_offset), "0")
			
		-- ComboBox
		Gui("Add","ComboBox","Choose1 R3 x432 w100 h20 vCanvasSize" .. " y" .. (80+y_offset),"1024x2048|2048x2048")
			
		y_offset = y_offset + 15
		for i=1,4 do
			-- GroupBox
			Gui("Add", "GroupBox", "x22 w300 h62 y" .. (45+y_offset), "Priority "..i)
		
			-- Button
			Gui("Add","Button","gBrowseMergeInputDir" .. i .. " x292 w25 h20 y" .. (59+y_offset),"...") -- Browse Input Directory
			
			-- Edit
			Gui("Add","Edit","x32 w260 h20 vInputMergeDir" .. i .. " y" .. (59+y_offset),"") -- Edit Input Directory

			y_offset = y_offset + 55
		end	
	
	Gui("Show", "w746 h549", "Open X-Ray Icon Texture Tool")

	load_settings()
end

function load_settings()
	for i=1,2 do
		-- Unpack
		GuiControl("", "OutputDir"..i, gSettings:GetValue("default","OutputDir"..i,""))
		GuiControl("", "InputTexture"..i, gSettings:GetValue("default","InputTexture"..i,""))
		GuiControl("", "SystemLTX"..i, gSettings:GetValue("default","SystemLTX"..i,""))
		
		-- Repack
		GuiControl("", "OutputTextureDir"..i, gSettings:GetValue("default","OutputTextureDir"..i,""))
		GuiControl("", "InputDir"..i, gSettings:GetValue("default","InputDir"..i,""))
		GuiControl("", "GamedataDir"..i, gSettings:GetValue("default","GamedataDir"..i,""))
		GuiControl("", "CanvasSize"..i, gSettings:GetValue("default","CanvasSize"..i,"1024x1024"))
		--GuiControl("", "OverwriteSystemLTX"..i, gSettings:GetValue("default","OverwriteSystemLTX"..i,"0"))
		--GuiControl("", "IgnoreSuggested"..i, gSettings:GetValue("default","IgnoreSuggested"..i,"0"))
		--GuiControl("", "RoughDraft"..i, gSettings:GetValue("default","RoughDraft"..i,"0"))
	end
	
	-- Merge
	GuiControl("", "OutputTextureDir", gSettings:GetValue("default","OutputTextureDir",""))
	GuiControl("", "GamedataDir", gSettings:GetValue("default","GamedataDir",""))
	GuiControl("", "CanvasSize", gSettings:GetValue("default","CanvasSize","1024x1024"))
	for i=1,4 do 
		GuiControl("", "InputMergeDir"..i, gSettings:GetValue("default","InputMergeDir"..i,""))
	end
	
	Gui("Submit","NoHide")
end 

function save_settings(i)
	if (ahkGetVar("TabName") == "Unpack") then
		gSettings:SetValue("default","OutputDir"..i,ahkGetVar("OutputDir"..i))
		gSettings:SetValue("default","InputTexture"..i,ahkGetVar("InputTexture"..i))
		gSettings:SetValue("default","SystemLTX"..i,ahkGetVar("SystemLTX"..i))
	elseif (ahkGetVar("TabName") == "Repack") then 
		gSettings:SetValue("default","OutputTextureDir"..i,ahkGetVar("OutputTextureDir"..i))
		gSettings:SetValue("default","InputDir"..i,ahkGetVar("InputDir"..i))
		gSettings:SetValue("default","GamedataDir"..i,ahkGetVar("GamedataDir"..i))
		gSettings:SetValue("default","CanvasSize"..i,s)
		--gSettings:SetValue("default","OverwriteSystemLTX"..i,ahkGetVar("OverwriteSystemLTX"..i))
		--gSettings:SetValue("default","IgnoreSuggested"..i,ahkGetVar("IgnoreSuggested"..i))
		--gSettings:SetValue("default","RoughDraft"..i,ahkGetVar("RoughDraft"..i))
	elseif (ahkGetVar("TabName") == "Merge") then
		gSettings:SetValue("default","OutputTextureDir",ahkGetVar("OutputTextureDir"))
		for i=1,4 do
			gSettings:SetValue("default","InputMergeDir"..i,ahkGetVar("InputMergeDir"..i))
		end
		gSettings:SetValue("default","GamedataDir",ahkGetVar("GamedataDir"))
		gSettings:SetValue("default","CanvasSize",s)
	end
	gSettings:Save()
end