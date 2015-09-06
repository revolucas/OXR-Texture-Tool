-- ; Author: Alundaio

local settings, item_list
	local m_classes =
	{
		["ARTEFACT"] = true,
		["SCRPTART"] = true,

		["II_ATTCH"] = true,
		["II_BTTCH"] = true,

		["II_DOC"]   = true,

		["TORCH_S"]  = true,

		["DET_SIMP"] = true,
		["DET_ADVA"] = true,
		["DET_ELIT"] = true,
		["DET_SCIE"] = true,

		["E_STLK"]   = true,
		["E_HLMET"]  = true,

		["II_BANDG"] = true,
		["II_MEDKI"] = true,
		["II_ANTIR"] = true,
		["II_BOTTL"] = true,
		["II_FOOD"]  = true,
		["S_FOOD"]   = true,

		["S_PDA"]    = true,
		["D_PDA"]    = true,

		["II_BOLT"]  = true,

		["WP_AK74"] = true,
		["WP_ASHTG"] = true,
		["WP_BINOC"] = true,
		["WP_BM16"] = true,
		["WP_GROZA"] = true,
		["WP_HPSA"] = true,
		["WP_KNIFE"] = true,
		["WP_LR300"] = true,
		["WP_PM"] = true,
		["WP_RG6"] = true,
		["WP_RPG7"] = true,
		["WP_SVD"] = true,
		["WP_SVU"] = true,
		["WP_VAL"] = true,

		["AMMO_S"]   = true,
		["S_OG7B"]   = true,
		["S_VOG25"]  = true,
		["S_M209"]   = true,

		["G_F1_S"]   = true,
		["G_RGD5_S"] = true,

		["WP_SCOPE"] = true,
		["WP_SILEN"] = true,
		["WP_GLAUN"] = true
	}
	
function xray_get_classes()
	return m_classes
end

function load_ltx(fname)
	local ltx = cIniFile:New(rem_quotes(fname))
	if (ltx) then
		return ltx
	end
end

-- Recreates ini as stored in the table
function cIniFile:SaveOrderByClass(lookup)
	local str = "",count

	if (self.includes) then
		for i=1,#self.includes do
			str = str .. self.includes[i] .. "\n"
		end
	end

	local function addTab(s,n)
		local l = string.len(s)
		for i=1,n-l do
			s = s .. " "
		end
		return s
	end

	local __t = {}
	local __c = {}

	-- order to list sections
	local __cls = {
		"II_BOLT",
		"TORCH_S",
		"S_PDA",
		"D_PDA",
		"II_DOC",
		"II_ATTCH",
		"II_BTTCH",

		"DET_SIMP",
		"DET_ADVA",
		"DET_ELIT",
		"DET_SCIE",

		"ARTEFACT",
		"SCRPTART",

		"II_FOOD",
		"S_FOOD",
		"II_BOTTL",

		"II_MEDKI",
		"II_BANDG",
		"II_ANTIR",

		"G_F1_S",
		"G_RGD5_S",

		"AMMO_S",
		"S_OG7B",
		"S_VOG25",
		"S_M209",

		"WP_SCOPE",
		"WP_SILEN",
		"WP_GLAUN",

		"WP_AK74",
		"WP_ASHTG",
		"WP_BINOC",
		"WP_BM16",
		"WP_GROZA",
		"WP_HPSA",
		"WP_KNIFE",
		"WP_LR300",
		"WP_PM",
		"WP_RG6",
		"WP_RPG7",
		"WP_SVD",
		"WP_SVU",
		"WP_VAL",

		"E_STLK",
		"E_HLMET"
	}

	for section,tbl in pairs(self.root) do
		if not (__t[section]) then
			__t[section] = {}
		end
		for key,val in pairs(self.root[section]) do
			if (lookup) then
				local cls = lookup:GetValue(key,"class",3)
				if (cls and m_classes[cls] == true) then
					if not (__c[cls]) then
						__c[cls] = {}
					end
					if not (__c[cls][section]) then
						__c[cls][section] = {}
					end
					table.insert(__c[cls][section],key)
				else
					table.insert(__t[section],key)
				end
			else
				table.insert(__t[section],key)
			end
		end
	end

	for k,v in pairs(__t) do
		table.sort(__t[k])
	end

	for k,v in pairs(__c) do
		for kk,vv in pairs(v) do
			table.sort(__c[k][kk])
		end
	end

	for section,tbl in pairs(self.root) do
		str = str .. "\n[" .. section .. "]\n"

		if (self.links and self.links[section]) then
			str = str .. ":"
			count = #self.links[section]
			for i=1,count do
				if (count > 1 and i ~= count) then
					str = str .. self.links[section][i] .. ","
				else
					str = str .. self.links[section][i]
				end
			end
		end
		for i,cls in pairs(__cls) do
			if (__c[cls] and __c[cls][section]) then
				str = str .. "\n;" .. cls .. "\n"
				for k,v in pairs(__c[cls][section]) do
					if (tbl[v] and tbl[v] ~= "nil") then
						if (tbl[v] == "") then
							str = str .. addTab(v,40) .. "\n"
						else
							str = str .. addTab(v,40) .. " = " .. tostring(tbl[v]) .. "\n"
						end
					end
				end
			end
		end
		for k,v in pairs(__t[section]) do
			if (tbl[v] and tbl[v] ~= "nil") then
				if (tbl[v] == "") then
					str = str .. addTab(v,40) .. "\n"
				else
					str = str .. addTab(v,40) .. " = " .. tostring(tbl[v]) .. "\n"
				end
			end
		end
	end

	local cfg = io.open(self.fname,"w+")
	cfg:write(str)
	cfg:close()
end

function system_ini()
	if not (settings) then
		settings = load_ltx(gSettings:GetValue("settings","system_ini","string"),true)
	end
	return settings
end 

function export_item_sections_to_file(ini)
	if not (item_list) then 
		return
	end
	
	item_list.root = {}

	for section,t in pairs(ini.root) do
		if (gSettings:GetValue("ignore_sections",section,"string") == nil) then
			if not (string.find(section,"mp_") == 1) then  -- IGNORE MP items
				if not (string.find(section,"ap_mp_")) then -- IGNORE MP items
					local v = ini:GetValue(section,"inv_name",3)
					if (v and v ~= "" and v ~= "default") then -- most likely an item, add to list
						item_list:SetValue("sections",section,"")
					end
				end
			end
		end
	end

	item_list:SaveOrderByClass(ini)
end

function get_item_sections_list(ini,reload)
	if (not reload and item_list and item_list.loaded == true) then 
		return item_list 
	end 
	
	item_list = load_ltx(".\\xray_sections.ltx")
	
	item_list.loaded = false 
	export_item_sections_to_file(ini)
	item_list.loaded = true
	
	return item_list
end

function order_by_class_and_execute(lookup,sections_by_alias,func)
	if not (lookup) then 
		log("order_by_class_and_execute: lookup ini is nil!")
		return
	end 
	
	local m_classes = xray_get_classes()
	
	-- order to list sections
	local __cls = {
		"UNKNOWN",
		"II_BOLT",
		"TORCH_S",
		
		"ARTEFACT",
		"SCRPTART",

		"II_FOOD",
		"S_FOOD",
		"II_BOTTL",

		"II_MEDKI",
		"II_BANDG",
		"II_ANTIR",
		
		"S_PDA",
		"D_PDA",
		"II_DOC",
		"II_ATTCH",
		"II_BTTCH",

		"DET_SIMP",
		"DET_ADVA",
		"DET_ELIT",
		"DET_SCIE",

		"G_F1_S",
		"G_RGD5_S",

		"AMMO_S",
		"S_OG7B",
		"S_VOG25",
		"S_M209",

		"WP_SCOPE",
		"WP_SILEN",
		"WP_GLAUN",

		"WP_AK74",
		"WP_ASHTG",
		"WP_BINOC",
		"WP_BM16",
		"WP_GROZA",
		"WP_HPSA",
		"WP_KNIFE",
		"WP_LR300",
		"WP_PM",
		"WP_RG6",
		"WP_RPG7",
		"WP_SVD",
		"WP_SVU",
		"WP_VAL",

		"E_STLK",
		"E_HLMET"
	}

	local function can_quit()
		for k,tbl in pairs(sections_by_alias) do
			if not (is_empty(tbl)) then 
				return false
			end
		end
		return true
	end 
	
	local __c,flip
	local sort_by_size = {w=1,h=1}
	while (not can_quit()) do
		__c = {}
		for alias,tbl in pairs(sections_by_alias) do
			for section,v in pairs(tbl) do
				local cls = lookup:GetValue(section,"class",3)
				if (cls and m_classes[cls] == true) then
					if not (__c[cls]) then
						__c[cls] = {}
					end
					table.insert(__c[cls],alias)
				else 
					if not (__c["UNKNOWN"]) then
						__c["UNKNOWN"] = {}
					end
					table.insert(__c["UNKNOWN"],alias)
				end
				break -- only need one section per alias since values are the same
			end
		end

		for k,v in pairs(__c) do
			table.sort(__c[k])
		end
		
		for i,cls in pairs(__cls) do
			if (__c[cls]) then
				for k,sec in pairs(__c[cls]) do
					func(sec,sort_by_size)
				end
			end
		end
		
		if not (flip) then 
			flip = true
			sort_by_size.w = sort_by_size.w + 1
		else 
			flip = false 
			sort_by_size.h = sort_by_size.h + 1
		end 
	end
end