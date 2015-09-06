-- ; Author: Alundaio

require'lua_extensions'
require'lfs'

function is_empty(t)
	for k,v in pairs(t) do 
		return false
	end
	return true
end
-- get output stream of os.execute
function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

-- prints a message safely for all lua datatypes
function printf(msg,...)
	msg = tostring(msg)
	if (select('#',...) >= 1) then
		local i = 0
		local p = {...}
		local function sr(a)
			i = i + 1
			if (type(p[i]) == 'userdata') then
				return 'userdata'
			end
			return tostring(p[i])
		end
		msg = string.gsub(msg,"%%s",sr)
	end
	print(msg)
end

-- Prints a formated lua table to print_table.txt for debugging purposes
function print_table(tbl,header,save_to_disk)
	if not (tbl) then 
		printf("print_table: Table is empty!")
		return
	end
	
	local txt = tostring(header) .. "\n{\n\n"
	local depth = 1

	local function tab(amt)
		local str = ""
		for i=1,amt, 1 do
			str = str .. "\t"
		end
		return str
	end

	local function table_to_string(tbl)
		local size = 0
		for k,v in pairs(tbl) do
			size = size + 1
		end

		local key
		local i = 1

		for k,v in pairs(tbl) do
			if (type(k) == "number") then
				key = "[" .. k .. "]"
			else
				key = "[\""..tostring(k) .. "\"]"
			end

			if (type(v) == "table") then
				txt = txt .. tab(depth) .. key .. " =\n"..tab(depth).."{\n"
				depth = depth + 1
				table_to_string(v,tab(depth))
				depth = depth - 1
				txt = txt .. tab(depth) .. "}"
			elseif (type(v) == "number" or type(v) == "boolean") then
				txt = txt .. tab(depth) .. key .. " = " .. tostring(v)
			elseif (type(v) == "userdata") then
				txt = txt .. tab(depth) .. key .. " = \"userdata\""
			else
				txt = txt .. tab(depth) .. key .. " = \"" .. tostring(v) .. "\""
			end

			if (i == size) then
				txt = txt .. "\n"
			else
				txt = txt .. ",\n"
			end

			i = i + 1
		end
	end

	table_to_string(tbl)

	txt = txt .. "\n}"

	if (save_to_disk) then
		local file = io.open("print_table.txt","a+")
		file:write(txt.."\n\n")
		file:close()
		printf("Table written to print_table.txt")
	end
	return txt
end

function directory_exists(path)
	return os.execute( "CD " .. path ) == 0
end

function file_exists(path)
	return io.open(path) ~= nil
end

function get_ext(s)
	return string.gsub(s,"(.*)%.","")
end

function startsWith(text,prefix)
	return string.sub(text, 1, string.len(prefix)) == prefix
end

function trim(s)
	return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

function get_path(str,sep)
    sep=sep or'\\'
    return str:match("(.*"..sep..")")
end

function get_current_dir(str,sep)
    sep=sep or'\\'
	str = str:reverse()
    return string.sub(str,1,string.find(str,sep)-1):reverse()
end


function pairsKeySorted(t, f)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)

    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end

    return iter
end

function str_explode(str,div,dont_trim)
	if not (dont_trim) then
		trim(str)
	end
	local t={}
	local cpt = string.find (str, div, 1, true)
	local a
	if cpt then
		repeat
			if not dont_trim then
				a = trim(string.sub(str, 1, cpt-1))
				table.insert( t, a )
			else
				table.insert( t, string.sub(str, 1, cpt-1) )
			end
			str = string.sub( str, cpt+string.len(div) )
			cpt = string.find (str, div, 1, true)
		until cpt==nil
	end
	if not dont_trim then
		a = trim(str)
		table.insert(t, a)
	else
		table.insert(t, str)
	end
	return t
end

-- INI Reader
function file_to_table(fname,parent,simple)
	local root = parent and parent.root or {}
	local sec,t,key,val
	for line in io.lines(fname) do
		if (line ~= "" and line ~= "\n") then
			if (startsWith(line, "#include")) then
				t = str_explode(line,";")
				t = str_explode(t[1],[["]])

				if (simple ~= true and parent ~= nil) then
					file_to_table(get_path(fname)..t[2],parent,simple)
				end
			elseif (startsWith(line, "[")) then
				t = str_explode(line,";")
				t = str_explode(t[1],":")

				sec = string.sub(t[1],2,-2)

				if (root[sec]) then
					printf("ERROR: Duplicate section exists! %s",line)
				end

				root[sec] = {}
				
				if (t[2]) then
					root[sec]["_____link"] = t[2]
					if (simple ~= true) then
						local a = str_explode(t[2],",")
						for k,v in pairs(a) do
							if (root[v]) then
								for kk,vv in pairs(root[v]) do
									root[sec][kk] = vv
								end
							end
						end
					end
				end
			elseif (not startsWith(line, ";") and not startsWith(line,"	") and not startsWith(line," ")) then
				t = str_explode(line,";")
				key = trim(string.match(t[1],"(.-)=") or t[1])
				if (key and key ~= "") then
					key = trim(key)
					val = string.match(t[1],"=(.+)")
					if (val) then
						val = trim(val)
					end

					if (sec) then
						root[sec] = root[sec] or {}
						root[sec][key] = val or ""
					else
						root[key] = val or ""
					end
				end
			end
		end
	end

	return root
end


cIniFile = {}
cIniFile.__index = cIniFile

function cIniFile:New(fname,simple_mode)
	local self = setmetatable({}, self)
	--printf("fname=%s",fname)
	local cfg = io.open(fname,"a+")
	if not (cfg) then
		return
	end
	cfg:close()
	self.fname = fname
	self.directory = get_path(fname) or ""

	self.root = {}
	file_to_table(fname,self,simple_mode)

	return self
end

function cIniFile:GetValue(sec,key,typ,def)
	local val = self.root and self.root[sec] and self.root[sec][key]
	if (val == nil) then
		return def
	end

	if (typ == 1 or typ == "bool") then
		return val == "true"
	elseif (typ == 2 or typ == "number") then
		return tonumber(val)
	end
	return val
end

function cIniFile:GetKeys(sec)
	if (self.root and self.root[sec]) then
		t={}
		for k,v in pairs(self.root[sec]) do 
			if (k ~= "_____link") then 
				t[k] = v
			end
		end
		return t
	end
end

function cIniFile:SetValue(sec,key,val)
	if not (self.root) then
		self.root = {}
	end

	if not (self.root[sec]) then
		self.root[sec] = {}
	end

	self.root[sec][key] = val == nil and "" or tostring(val)
end

function cIniFile:ClearValue(sec,key)
	if not (self.root) then
		self.root = {}
	end

	if not (self.root[sec]) then
		self.root[sec] = {}
	end
	self.root[sec][key] = nil
end

function cIniFile:SectionExist(sec)
	return self.root and self.root[sec] ~= nil
end

function cIniFile:KeyExist(sec,key)
	return self.root and self.root[sec] and self.root[sec][key] ~= nil
end

-- Save ini by preserving original file. Cannot insert new keys or sections
function cIniFile:SaveExt()
	local t,sec,comment
	local str = ""

	local function addTab(s,n)
		local l = string.len(s)
		for i=1,n-l do
			s = s .. " "
		end
		return s
	end

	for ln in io.lines(self.fname) do
		ln = trim(ln)
		if (startsWith(ln,"[")) then
			t = str_explode(ln,";")
			t = str_explode(t[1],":")

			sec = string.sub(t[1],2,-2)
		elseif (not startsWith(ln,";") and self.root[sec]) then
			comment = string.find(ln,";")
			comment = comment and string.sub(ln,comment) or ""

			if (comment ~= "") then
				comment = addTab("\t",40) .. comment
			end

			t = str_explode(ln,"=")
			if (self.root[sec][t[1]] ~= nil) then
				if (self.root[sec][t[1]] == "") then
					ln = addTab(t[1],40) .. " =" .. comment

				else
					ln = addTab(t[1],40) .. " = " .. tostring(self.root[sec][t[1]]) .. comment
				end
			end
		end
		str = str .. ln .. "\n"
	end
	local cfg = io.open(self.fname,"w+")
	cfg:write(str)
	cfg:close()
end

-- Recreates ini as stored in the table
function cIniFile:Save()
	local _s = {}
	_s.__order = {}
	
	for section,tbl in pairs(self.root) do
		table.insert(_s.__order,section)
		if not (_s[section]) then 
			_s[section] = {}
		end
		for k,v in pairs(tbl) do 
			table.insert(_s[section],k)
		end
	end
	
	table.sort(_s.__order)
	
	for i,section in pairs(_s.__order) do 
		table.sort(_s[section])
	end 
	
	local str = ""
	
	local first
	for i,section in pairs(_s.__order) do
		if not (first) then
			str = str .. "[" .. section .. "]"
			first = true
		else 
			str = str .. "\n[" .. section .. "]"
		end

		if (self.root["_____link"]) then 
			str = str .. ":" .. self.root["_____link"] .. "\n"
		else 
			str = str .. "\n"
		end 

		for ii, key in pairs(_s[section]) do
			val = self.root[section][key]
			if (val == "") then
				str = str .. key .. "\n"
			else
				str = str .. key .. " = " .. tostring(val) .. "\n"
			end
		end 
	end 

	local cfg = io.open(self.fname,"w+")
	cfg:write(str)
	cfg:close()
end

function round(num)
    under = math.floor(num)
    upper = math.floor(num) + 1
    underV = -(under - num)
    upperV = upper - num
    if (upperV > underV) then
        return under
    else
        return upper
    end
end

function rem_quotes(txt)
	if not (txt) then return end
	for w in string.gmatch(txt,"[\"'](.+)[\"']") do
		return w
	end
	return txt
end

function recurse_subdirectories_and_execute(node,ext,func,...)
	local stack = {}
	local deepest
	while not deepest do
		if (node) then
			for file in lfs.dir(node) do
				if lfs.attributes(file,"mode") == "file" then
					printf(file)
				elseif lfs.attributes(file,"mode") == "directory" then
					if (file == ".") then
						for l in lfs.dir(node) do
							if (l ~= ".." and l ~= ".") then
								if lfs.attributes(node.."\\"..file.."\\"..l,"mode") == "file" then
									for i=1,#ext do
										if (get_ext(l) == ext[i]) then
											func(node,l,...)
										end
									end
								elseif lfs.attributes(node.."\\"..file.."\\"..l,"mode") == "directory" then
									--print(node .. "\\"..l)
									table.insert(stack,node .. "\\" .. l)
								end
							end
						end
					end
				end
			end
		end

		if (#stack > 0) then
			node = stack[#stack]
			stack[#stack] = nil
		else
			deepest = true
		end
	end
end

function copy_file_data(file,fullpath,data,overwrite)
	if not (file) then
		return 0
	end

	if not (file_exists(fullpath)) then
		-- create the directory for a newly copied file
		for dir in string.gmatch(fullpath,"(.+)\\","") do
			dir = trim(dir)
			if not (directory_exists(dir)) then
				os.execute('MD "'..dir..'"')
			end
		end
		local output_file = io.open(fullpath,"wb+")
		if (output_file) then
			data = data or file:read("*all")
			if (data) then
				output_file:write(data)
				output_file:close()
				return 1
			end
		else
			return -1
		end
	else
		return 2
	end
	return 0
end

--[[
					Global	Settings and Log
--]]
-- Setup main configuration
ERROR_COUNT = 0
gSettings = cIniFile:New(".\\settings.ini")
if not (gSettings) then
	printf("configuration is missing for axr_lua_engine!")
	return false
end

-- setup error log
gErrorLog = io.open("errors.log","w")
if (gErrorLog) then
	gErrorLog:write("")
	gErrorLog:close()
end

gErrorLog = io.open("errors.log","a+")

function log(msg,...)
	if not (gErrorLog) then
		return
	end
	msg = tostring(msg)
	if (select('#',...) >= 1) then
		local i = 0
		local p = {...}
		local function sr(a)
			i = i + 1
			if (type(p[i]) == 'userdata') then
				return 'userdata'
			end
			return tostring(p[i])
		end
		msg = string.gsub(msg,"%%s",sr)
	end
	ERROR_COUNT = ERROR_COUNT + 1
	gErrorLog:write(msg.."\n")
end

function log_flush()
	gErrorLog:close()
	gErrorLog = io.open("errors.log","a+")
end	



