function action_save_section_to_system_ltx(dir,geometry)
	local function on_execute(path,filename)
		local fullpath = path.."\\"..filename
		local ltx = io.open(fullpath,"rb")
		if (ltx) then
			local data = ltx:read("*all")
			ltx:close()
			if (data) then
				ltx = nil
				if (geometry.section and string.find(data,"["..geometry.section.."]",nil,true)) then
					ltx = load_ltx(fullpath,true)
					if (ltx) then
						if (geometry.x) then 
							ltx:SetValue(geometry.section,"inv_grid_x",geometry.x)
						end
						if (geometry.y) then 
							ltx:SetValue(geometry.section,"inv_grid_y",geometry.y)
						end
						if (geometry.w) then 
							ltx:SetValue(geometry.section,"inv_grid_width",geometry.w)
						end
						if (geometry.h) then 
							ltx:SetValue(geometry.section,"inv_grid_height",geometry.h)
						end						
						ltx:SaveExt()
					end
				end
				if (geometry.attachment_section and string.find(data,"["..geometry.attachment_section.."]",nil,true)) then
					ltx = ltx or load_ltx(fullpath,true)
					if (ltx) then
						if (geometry.offset_x) then
							--ltx:SetValue(geometry.attachment_section,self._addons[ind].."_x",geometry.offset_x)
						end 
						if (geometry.offset_y) then
							--ltx:SetValue(geometry.attachment_section,self._addons[ind].."_y",geometry.offset_y)
						end
						ltx:SaveExt()
					end
				end
			end
		end
	end

	on_execute(dir,"system.ltx")
	recurse_subdirectories_and_execute(dir.."\\weapons",{"ltx"},on_execute)
	recurse_subdirectories_and_execute(dir.."\\misc",{"ltx"},on_execute)
end