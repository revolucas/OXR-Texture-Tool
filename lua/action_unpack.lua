-- ; Author: Alundaio

function action_unpack_ui_equipment_icons(index)
	local input_texture = ahkGetVar("InputTexture"..index)
	if not (input_texture) then
		Msgbox("You must select an input texture!")
		return
	end

	if not (os.rename(input_texture,input_texture)) then
		Msgbox("Input texture does not exist!")
		return
	end

	local output_dir = ahkGetVar("OutputDir"..index)
	if not (output_dir) then
		Msgbox("Please provide a valid output directory!")
		return
	end

	local ltx = load_ltx(output_dir .. "\\shared.ltx")
	ltx.root = {} -- clear ini

	local alias = {}

	local ini = ahkGetVar("SystemLTX"..index)
	ini = ini and load_ltx(ini)
	if not (ini) then
		Msgbox("Failed to load system.ltx!")
		return
	end

	local overwrite = ahkGetVar("OverwriteCheckbox"..index) == "1"

	gItemList = get_item_sections_list(ini,true)

	local w,h,x,y

	local sections = gItemList:GetKeys("sections")

	local max_count,count = 0,0
	for k,v in pairs(sections) do
		max_count = max_count + 1
	end

	if (max_count == 0) then
		Msgbox("Failed to create a list of sections using system.ltx, check settings!")
		return
	end

	local upgr_mode = ahkGetVar("MechanicModeCheckbox"..index) == "1"

	if not (upgr_mode) then
		sections["___upgr_icon1"] = true
		sections["___upgr_icon2"] = true
	end

	for sec,v in pairs(sections) do
		if (sec == "___upgr_icon1") then
			w = 50
			h = 50
			x = 0
			y = 40 * 50
		elseif (sec == "___upgr_icon2") then
			w = 50
			h = 50
			x = 50
			y = 40 * 50
		else
			if (upgr_mode) then
				w = ini:GetValue(sec,"upgr_icon_width",2,0)
				h = ini:GetValue(sec,"upgr_icon_height",2,0)
				x = ini:GetValue(sec,"upgr_icon_x",2,0)
				y = ini:GetValue(sec,"upgr_icon_y",2,0)
			else
				w = ini:GetValue(sec,"inv_grid_width",2,0)*50
				h = ini:GetValue(sec,"inv_grid_height",2,0)*50
				x = ini:GetValue(sec,"inv_grid_x",2,0)*50
				y = ini:GetValue(sec,"inv_grid_y",2,0)*50
			end
		end

		if not (alias[w]) then
			alias[w] = {}
		end

		if not (alias[w][h]) then
			alias[w][h] = {}
		end

		if not (alias[w][h][x]) then
			alias[w][h][x] = {}
		end

		if not (alias[w][h][x][y]) then
			alias[w][h][x][y] = sec

			--lfs.mkdir(output_dir .. "\\" .. sec)

			local fn =  output_dir .. "\\" .. sec .. ".png"
			local exists = os.rename(fn,fn) or false

			if (exists ~= true or overwrite) then
				local geo = tostring(w) .. "x" .. tostring(h) .. "+" .. tostring(x) .. "+" .. tostring(y)
				--os.capture(lfs.currentdir() .. [[/bin/ImageMagick/convert.exe ui_icon_equipment.dds -crop ]] .. geo .. " " .. output_dir .. "\\" .. sec .. "\\" .. sec .. ".png")
				local pid = RunWait(lfs.currentdir() .. [[/bin/ImageMagick/convert.exe "]] .. input_texture .. [[" -crop ]] .. geo .. " " .. fn," ", "Hide UseErrorLevel")
				if not (pid) then
					Msgbox("Failed to launch bin\\ImageMagick\\convert.exe! Add it to exceptions for Anti-virus!")
					return
				end
				WinWaitClose("ahk_pid " .. pid)
				local ErrorLevel = ahkGetVar("ErrorLevel")
				local err = ahkGetVar("A_LastError")
				if (ErrorLevel ~= "0" and err ~= "0") then
					Msgbox("System Error Code: "..err .. "\nErrorLevel="..ErrorLevel.."\ninput=" .. input_texture .. "\nfilename="..fn)
					return
				end
			end
		end

		ltx:SetValue(alias[w][h][x][y],sec,"")
		if (upgr_mode) then
			ltx:SetValue(alias[w][h][x][y],"_suggested_x",x)
			ltx:SetValue(alias[w][h][x][y],"_suggested_y",y)
			ltx:SetValue(alias[w][h][x][y],"_grid_width",w)
			ltx:SetValue(alias[w][h][x][y],"_grid_height",h)
		else
			ltx:SetValue(alias[w][h][x][y],"_suggested_x",x/50)
			ltx:SetValue(alias[w][h][x][y],"_suggested_y",y/50)
			ltx:SetValue(alias[w][h][x][y],"_grid_width",w/50)
			ltx:SetValue(alias[w][h][x][y],"_grid_height",h/50)
		end

		count = count + 1
		GuiControl("", "UnpackProgress"..index, tostring( (count/max_count)*100 ) )
	end

	GuiControl("", "UnpackProgress"..index, "0")

	ltx:Save()
end
