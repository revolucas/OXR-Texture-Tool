function matrix(w,h)
	local function new()
		local _t = {}
		for i=1,h do
			_t[i] = {}
			for ii=1,w do
				_t[i][ii] = 0
			end
		end
		return _t
	end

	local t = new()

	function t.set(self,x,y,z)
		self[1][1] = x
		self[2][2] = y
		self[3][3] = z
		self[4][4] = 1
	end

	function t.clone(self)
		local function deepcopy(orig)
			local orig_type = type(orig)
			local copy
			if orig_type == 'table' then
				copy = {}
				for orig_key, orig_value in next, orig, nil do
					copy[deepcopy(orig_key)] = deepcopy(orig_value)
				end
				setmetatable(copy, deepcopy(getmetatable(orig)))
			else -- number, string, boolean, etc
				return orig
			end
			return copy
		end
		return deepcopy(self)
	end

	function t.scale(self,x,y,z)
		self[1][1] = x
		self[2][2] = y
		self[3][3] = z
		self[4][4] = 1
	end

	function t.mul(self,A,B)
		assert(self ~= A and self ~= B)
		self[1][1] = A[1][1] * B[1][1] + A[2][1] * B[1][2] + A[3][1] * B[1][3] + A[4][1] * B[1][4]
		self[1][2] = A[1][2] * B[1][1] + A[2][2] * B[1][2] + A[3][2] * B[1][3] + A[4][2] * B[1][4]
		self[1][3] = A[1][3] * B[1][1] + A[2][3] * B[1][2] + A[3][3] * B[1][3] + A[4][3] * B[1][4]
		self[1][4] = A[1][4] * B[1][1] + A[2][4] * B[1][2] + A[3][4] * B[1][3] + A[4][4] * B[1][4]

		self[2][1] = A[1][1] * B[2][1] + A[2][1] * B[2][2] + A[3][1] * B[2][3] + A[4][1] * B[2][4]
		self[2][2] = A[1][2] * B[2][1] + A[2][2] * B[2][2] + A[3][2] * B[2][3] + A[4][2] * B[2][4]
		self[2][3] = A[1][3] * B[2][1] + A[2][3] * B[2][2] + A[3][3] * B[2][3] + A[4][3] * B[2][4]
		self[2][4] = A[1][4] * B[2][1] + A[2][4] * B[2][2] + A[3][4] * B[2][3] + A[4][4] * B[2][4]

		self[3][1] = A[1][1] * B[3][1] + A[2][1] * B[3][2] + A[3][1] * B[3][3] + A[4][1] * B[3][4]
		self[3][2] = A[1][2] * B[3][1] + A[2][2] * B[3][2] + A[3][2] * B[3][3] + A[4][2] * B[3][4]
		self[3][3] = A[1][3] * B[3][1] + A[2][3] * B[3][2] + A[3][3] * B[3][3] + A[4][3] * B[3][4]
		self[3][4] = A[1][4] * B[3][1] + A[2][4] * B[3][2] + A[3][4] * B[3][3] + A[4][4] * B[3][4]

		self[4][1] = A[1][1] * B[4][1] + A[2][1] * B[4][2] + A[3][1] * B[4][3] + A[4][1] * B[4][4]
		self[4][2] = A[1][2] * B[4][1] + A[2][2] * B[4][2] + A[3][2] * B[4][3] + A[4][2] * B[4][4]
		self[4][3] = A[1][3] * B[4][1] + A[2][3] * B[4][2] + A[3][3] * B[4][3] + A[4][3] * B[4][4]
		self[4][4] = A[1][4] * B[4][1] + A[2][4] * B[4][2] + A[3][4] * B[4][3] + A[4][4] * B[4][4]
	end

	function t.mulA_44(self,A)
		B = self:clone()
		self:mul(A,B)
	end

	function t.mulB_44(self,B)
		A = self:clone()
		self:mul(A,B)
	end

	function t.printf(self)
		local col = ""
		for i=1,h do
			for ii=1,w do
				if (self[i][ii] == nil) then 
					print(i,ii)
				end
				col = col .. "|" .. self[i][ii]
			end
			print(col)
			col = ""
		end
	end

    function t.find_free(self,width,height,_x,_y,v)
		local try_again = _x ~= nil and _y ~= nil
		_x = _x or 1
		_y = _y or 1
		
		if (_x > w or _y > h) then
			return nil,nil,true
		end
		
		for y=_y,h do
			for x=_x,w do
				if (self[y][x] == 0 and y+height-1 <= h and x+width-1 <= w and self[y+height-1][x] == 0 and self[y+height-1][x+width-1] == 0 and self[y][x+width-1] == 0) then
					local free = false
					for a=1,height do
						for b=1,width do
							if (self[y+a-1][x+b-1] == 0) then
								free = true
							else
								free = false
								break
							end
						end
						if not (free) then 
							break
						end
					end
					if (free) then
						for b=1,width do
							for a=1,height do
								if (self[y+a-1][x+b-1] == 0) then
									free = true
								else
									free = false
									break
								end
							end
						end
						if not (free) then 
							break
						end
					end
					if (free) then
						for a=1,height do
							for b=1,width do
								self[y+a-1][x+b-1] = v
							end
						end
						for b=1,width do
							for a=1,height do
								self[y+a-1][x+b-1] = v
							end
						end
						return x,y
					elseif (try_again) then 
						return nil,nil,true
					end
				elseif (try_again) then 
					return nil,nil,true
				end
			end
		end
    end

	return t
end


