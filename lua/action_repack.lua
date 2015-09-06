-- ; Author: Alundaio

function action_repack_ui_equipment_icons(index)

	local output_dir = ahkGetVar("OutputTextureDir"..index)
	if not (output_dir) then
		Msgbox("Please provide a valid output texture directory!")
		return
	end 

	local input_dir = ahkGetVar("InputDir"..index)
	if not (input_dir) then 
		Msgbox("Please provide a valid input directory! It should contain shared.ltx and all the icon directories.")
		return
	end 
	
	local ltx = load_ltx(input_dir .. "\\shared.ltx")
	if not (ltx) then 
		Msgbox("Cannot find shared.ltx in input directory!")
		return
	end
	
	local is_valid = false
	for k,v in pairs(ltx.root) do
		is_valid = true
	end
	
	if not (is_valid) then 
		Msgbox("shared.ltx is not valid, check input directory!")
		return
	end
	
	local canvas_size = ahkGetVar("CanvasSize"..index)
	local p = canvas_size and str_explode(canvas_size,"x")
	if not (p and p[1] and p[2] and string.find(canvas_size,"x")) then 
		Msgbox("Invalid canvas size!")
		return
	end
	
	local gamedata_dir = ahkGetVar("GamedataDir"..index)
	if not (gamedata_dir) then 
		Msgbox("Please specify a gamedata directory")
		return
	end 
	
	local ini = gamedata_dir .. "\\configs\\system.ltx"
	ini = ini and load_ltx(ini)
	if not (ini) then 
		Msgbox("Failed to load system.ltx!")
		return
	end
	
	if not (ini:SectionExist("demo_record")) then 
		Msgbox("system.ltx is invalid, check path!")
		return
	end
	
	local draft_only = ahkGetVar("RoughDraft"..index) == "1"
	local ignore_suggested = ahkGetVar("IgnoreSuggested"..index) == "1"
	local overwrite = ahkGetVar("OverwriteSystemLTX"..index) == "1"
	
	local max_w = tonumber(p[1])
	local max_row = round(max_w/50)
	local max_h = tonumber(p[2])
	local max_col = round(max_h/50)
	local m = matrix(max_row,max_col)
	
	local alias_by_section = {}
	local sections_by_alias = {}
	local max_count = 0
	local function make_list(p,fn,ltx)
		local fullpath = p .. "\\" .. fn
		local alias = fn:sub(0,-5) --get_current_dir(p)
		local seclist = ltx:GetKeys(alias)
		if not (seclist) then 
			log("Error: section %s is empty!",alias)
			return
		end
		for k,v in pairs(seclist) do
			if (k ~= "_suggested_x" and k ~= "_suggested_y" and k ~= "_grid_width" and k ~= "_grid_height") then
				if not (sections_by_alias[alias]) then 
					sections_by_alias[alias] = {}
				end
		
				if (alias_by_section[k] and sections_by_alias[alias_by_section[k]]) then 
					sections_by_alias[alias_by_section[k]][k] = nil
				end
		
				alias_by_section[k] = alias
				sections_by_alias[alias][k] = {p=p,fn=fn,ltx=ltx}		
			
				max_count = max_count + 1
			end
		end
	end
	
	local c = 0
	local first,w,h,s_x,s_y,x,y,n
	local dont_use_suggested = {}
	local function make_composite(alias,sort_by_size)
		--print("debug make composite")
		
		local p,fn,s_ltx
		for _sec,tbl in pairs(sections_by_alias[alias]) do 
			s_ltx = tbl.ltx
			p = tbl.p
			fn = tbl.fn
			break
		end 
		
		if not (s_ltx) then
			log("Error: s_ltx is nil!")
			return
		end

		if (alias == "___upgr_icon1") then 
			w = 1
			h = 1
		elseif (alias == "___upgr_icon2") then 
			w = 1
			h = 1
		else
			w = s_ltx:GetValue(alias,"_grid_width",2)
			h = s_ltx:GetValue(alias,"_grid_height",2)
		end
		
		if (w and h) then
			local fullpath = p .. "\\" .. fn
			if (alias == "___upgr_icon1" or alias == "___upgr_icon2") then 
				s_x = s_ltx:GetValue(alias,"_suggested_x",2)
				s_y = s_ltx:GetValue(alias,"_suggested_y",2)		
			else 
				s_x = not ignore_suggested and s_ltx:GetValue(alias,"_suggested_x",2)
				s_y = not ignore_suggested and s_ltx:GetValue(alias,"_suggested_y",2)
			end
			
			if (h <= sort_by_size.h and w <= sort_by_size.w) then
				if (dont_use_suggested[alias]) then 
					x,y,n = m:find_free(w,h,nil,nil,1)
				else 
					x,y,n = m:find_free(w,h,s_x and s_x+1 or nil,s_y and s_y+1 or nil,1)
				end
				if (n == true) then 
					dont_use_suggested[alias] = true
				end
			else 
				n = true
			end
			
			if (n == true) then 
				-- don't remove index in list
			elseif (x and y) then
				c = c + 1
				local real_x = (x-1)*50
				local real_y = (y-1)*50
				local real_w = w*50
				local real_h = h*50
				
				Gui("2:Add","Picture", "w"..tostring(real_w) .. " h" ..tostring(real_h) .. " x"..tostring(real_x) .. " y"..tostring(real_y), fullpath)
				
				if not (first) then
					if not (draft_only) then
						RunWait(lfs.currentdir() .. [[/bin/ImageMagick/composite.exe -geometry ]] .. real_w .. "x" .. real_h .. "+" .. real_x .. "+" .. real_y .. [[ "]] .. fullpath .. [[" canvas_ui_icon_equipment.png "]] .. output_dir .. [[/new_ui_icon_equipment.png"]]," ", "Hide UseErrorLevel")
					end
					first = true
				else 
					if not (draft_only) then
						RunWait(lfs.currentdir() .. [[/bin/ImageMagick/composite.exe -geometry ]] .. real_w .. "x" .. real_h .. "+" .. real_x .. "+" .. real_y .. [[ "]] .. fullpath .. [[" "]] .. output_dir .. [[/new_ui_icon_equipment.png" "]] .. output_dir .. [[/new_ui_icon_equipment.png"]],"", "Hide UseErrorLevel")
					end
				end
				for _section,v in pairs (sections_by_alias[alias]) do
				if (overwrite == true and sec ~= "___upgr_icon1" and sec ~= "___upgr_icon2") then 
						action_save_section_to_system_ltx(gamedata_dir.."\\configs",{section=_section,x=x-1,y=y-1,w=w,h=h})
					end 
					sections_by_alias[alias][_section] = nil
				end
			else
				for _section,v in pairs (sections_by_alias[alias]) do
					sections_by_alias[alias][_section] = nil
				end
				c = c + 1
				log("Failed to find free space on canvas! Use a larger canvas size! [%s] %s",sec,fullpath)
			end
		else
			for _section,v in pairs (sections_by_alias[alias]) do
				sections_by_alias[alias][_section] = nil
			end
			c = c + 1
			log("Failed to get valid width and/or height! [%s] %s",sec,fullpath)
		end
		GuiControl("", "RepackProgress"..index, tostring( (c/max_count)*100 ) )
	end
	
	if not (draft_only) then
		RunWait(lfs.currentdir() .. [[/bin/ImageMagick/convert.exe -size ]] .. canvas_size .. [[ xc:none canvas_ui_icon_equipment.png]]," ", "Hide UseErrorLevel")
	end
	
	--print("before makelist")
	recurse_subdirectories_and_execute(input_dir,{"png"},make_list,ltx)
	--print("after makelist")
	
	if (max_count == 0) then
		Msgbox("Failed to make a list using input directory and shared.ltx!")
		return
	end 
	
	--print_table(icon_sections_list,"___",true)
	
	Gui("2:Destroy")
	Gui("2:Show", "w1024 h768", "ui_equipment_icon")
	Gui("2:+0x300000")
	GroupAdd("SpriteSheet","ui_equipment_icon")
	
	order_by_class_and_execute(ini,sections_by_alias,make_composite)
	
	GuiControl("", "RepackProgress"..index, "0")
	ahkFunction("UpdateScrollBars","2","1024","768")
	
	if (ERROR_COUNT > 0) then
		log_flush()
		Msgbox("There were " .. ERROR_COUNT .. " errors. Check log!")
	end
end 