function action_save_repack(dir,geometry)
	local function on_execute(path,filename)
		local fullpath = path.."\\"..filename
		local ltx = io.open(fullpath,"rb")
		if (ltx) then
			local data = ltx:read("*all")
			ltx:close()
			if (data) then
				ltx = nil
				if (geometry.section) then
					ltx = load_ltx(fullpath,true)
					if (ltx) then
						if (geometry.x) then
							ltx:SetValue(geometry.section,"x",geometry.x)
						end
						if (geometry.y) then
							ltx:SetValue(geometry.section,"y",geometry.y)
						end
						if (geometry.w) then
							ltx:SetValue(geometry.section,"width",geometry.w)
						end
						if (geometry.h) then
							ltx:SetValue(geometry.section,"height",geometry.h)
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
