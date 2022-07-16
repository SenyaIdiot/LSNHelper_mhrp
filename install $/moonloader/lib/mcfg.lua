local Mcfg = {
	_VERSION	= "1.1.1",
	_AUTHOR		= "Double Tap Inside",
	_EMAIL		= "double.tap.inside@gmail.com"
	
	--[[
		Module mcfg				= require "mcfg"
		
		Bool result				= mcfg.update(Table original, Table update / Str update_filename,  [Bool rewrite=true])
		Bool result				= mcfg.save(Table updated, Str filename)
				
		nil						= mcfg.mkpath(Str filename)
		Table loaded / nil		= mcfg.load(Str filename)
		
		Bool result				= mcfg.append_pair(Str/Int key, value, Str filename)
		Bool result				= mcfg.append_value(value, Str filename)
	--]]
}

function Mcfg.__init()
	local self = {}
	
	
	local function draw_string(str)
		str = str:gsub("\n", "\\n" )
				
		if string.match(str:gsub("[^'\"]", ""), '^"+$') then
			return "'"..str.."'"
		end
				
		return '"'..str:gsub('"', '\\"')..'"'
	end


	local function draw_key(key)
		if "string" == type(key) and key:match("^[_%a][_%a%d]*$") then
			return key
			
		elseif "number" == type(key) then
			return "["..key.."]"

		else
			return "["..draw_string(key).."]"
		end
	end
	
	
	local function draw_table(tbl, tab)
		local tab = tab or ""
		local result = {}
		
		for key, value in pairs(tbl) do
			if type(value) == "string" then
				if type(key) == "number" and key <= #tbl then
					table.insert(result, draw_string(value))
					
				else
					table.insert(result, draw_key(key).." = "..draw_string(value))
				end
				
			elseif type(value) == "number" or type(value) == "boolean" then
				if type(key) == "number" and key <= #tbl then
					table.insert(result, tostring(value))
					
				else
					table.insert(result, draw_key(key).." = "..tostring(value))
				end
			
			elseif type(value) == "table" then
				if type(key) == "number" and key <= #tbl then
					table.insert(result, draw_table(value, tab.."\t"))
					
				else
					table.insert(result, draw_key(key).." = "..draw_table(value, tab.."\t"))
				end
				
			else
				if type(key) == "number" and key <= #tbl then
					table.insert(result, draw_string(tostring(value)))
					
				else
					table.insert(result, draw_key(key).." = "..draw_string(tostring(value)))
				end
			end
		end
		
		if #result == 0 and tab == "" then
			return ""
			
		elseif #result == 0 then
			return "{}"
		
		elseif tab == "" then
			return table.concat(result, ",\n")..",\n"
		
		else
			return "{\n"..tab..table.concat(result, ", \n"..tab)..",\n"..tab:sub(2).."}"
		end       
	end
	
	
	local function draw_value(value, tab)
		if type(value) == "string" then
			return draw_string(value)
		
		elseif type(value) == "number" or type(value) == "boolean" or type(value) == "nil" then
			return tostring(value)
		
		elseif type(value) == "table" then
			return draw_table(value, tab)
			
		else
			return draw_string(tostring(value))
		end
	end
	
	
	function self.mkpath(filename)
		assert(type(filename)=="string", ("bad argument #1 to 'mkpath' (string expected, got %s)"):format(type(filename)))
	
		local sep, pStr = package.config:sub(1, 1), ""
		local path = filename:match("(.+"..sep..").+$") or filename
		
		for dir in path:gmatch("[^" .. sep .. "]+") do
			pStr = pStr .. dir .. sep
			createDirectory(pStr)
		end
	end
	
	
	function self.load(filename)
		assert(type(filename)=="string", ("bad argument #1 to 'load' (string expected, got %s)"):format(type(filename)))
	
		local file = io.open(filename, "r")
		
		if file then 	
			local text = file:read("*all")
			file:close()
			local lua_code = loadstring("return {"..text.."}")
			
			if lua_code then
				local result = lua_code()
				
				if type(result) == "table" then
					return result
				end
			end
		end
	end
	
	
	function self.save(updated, filename)
		assert(type(updated)=="table", ("bad argument #1 to 'save' (table expected, got %s)"):format(type(updated)))
		assert(type(filename)=="string", ("bad argument #2 to 'save' (string expected, got %s)"):format(type(filename)))
	
		self.mkpath(filename)
		local file = io.open(filename, "w+")
		
		if file then
			local text = draw_table(updated)
			file:write(text)
			file:close()
			
			return true
		else
			return false
		end
	end
	
	
	function self.append_value(value, filename)
		assert(type(filename)=="string", ("bad argument #2 to 'save' (string expected, got %s)"):format(type(filename)))
		
		self.mkpath(filename)
		local file = io.open(filename, "a+")
		
		if file then
			file:write(draw_value(value, "\t")..",\n")
			file:close()
			
			return true
		else
			return false
		end
	end
	
	
	function self.append_pair(key, value, filename)
		assert(type(filename)=="string", ("bad argument #3 to 'append_pair' (string expected, got %s)"):format(type(filename)))
		assert(type(key)=="string" or type(key)=="number", ("bad argument #1 to 'append_pair' (string or number expected, got %s)"):format(type(key)))
		
		self.mkpath(filename)
		local file = io.open(filename, "a+")
		
		if file then		
			file:write("\n"..draw_key(key).." = "..draw_value(key)..",")
			file:close()
			
			return true
		else
			return false
		end
	end
	
	
	function self.update(original, update, rewrite)
		assert(type(original)=="table", ("bad argument #1 to 'update' (table expected, got %s)"):format(type(original)))
		assert(type(update)=="string" or type(update)=="table", ("bad argument #2 to 'update' (string or table expected, got %s)"):format(type(update)))
		assert(type(rewrite)=="boolean" or type(rewrite)=="nil", ("bad argument #1 to 'update' (boolean or nil expected, got %s)"):format(type(rewrite)))
		
		if rewrite == nil then
			rewrite = true
		end
	
		if type(update) == "table" then
			if rewrite then
				for key, value in pairs(update) do
					original[key] = value
				end
				
			else
				for key, value in pairs(update) do
					if not original[key] then
						original[key] = value
					end
				end
			end
			
			return true
			
		elseif type(update) == "string" then
			local loaded = self.load(update)
			
			if loaded then
				if rewrite then
					for key, value in pairs(loaded) do
						original[key] = value
					end
					
				else
					for key, value in pairs(loaded) do
						if not original[key] then
							original[key] = value
						end
					end
				end
				
				return true
			end
		end
		
		return false
	end
	
	return self
end

setmetatable(Mcfg, {
	__call = function(self)
		return self.__init()
	end
})

return Mcfg()




