local mod = {}

function mod.checkType(...)
   local dinfo = debug.getinfo(2, "n")
   local len = select('#', ...)
   for i = 1, len, 2 do
      local validType = tostring(select(i, ...))
      local typeList = split(validType, "|")
      local curentType = type(select(i + 1, ...))
      if #typeList > 1 then
         local searched = false
         for i = 1, #typeList do
            if curentType == typeList[i] then
               searched = true
               break
            end
         end
         if not searched then
            assert(false, ("bad argument #%d to '%s' (%s expected, got %s)"):format(math.floor((i + 1) / 2), dinfo.name, validType, curentType))
         end
      else
         assert(curentType == validType, ("bad argument #%d to '%s' (%s expected, got %s)"):format(math.floor((i + 1) / 2), dinfo.name, validType, curentType))
      end
   end
end

function mod.checkGenType(gtype, ...)
   local dinfo = debug.getinfo(2, "n")
   local len = select('#', ...)
   for i = 1, len do
      local curentType = type(select(i, ...))
      assert(curentType == gtype, ("bad argument #%d to '%s' (%s expected, got %s)"):format(i, dinfo.name, gtype, curentType))
   end
end

function split(str, delim, plain) -- bh FYP
   local tokens, pos, plain = {}, 1, not (plain == false) --[[ delimiter is plain text by default ]]
   repeat
       local npos, epos = string.find(str, delim, pos, plain)
       table.insert(tokens, string.sub(str, pos, npos and npos - 1))
       pos = epos and epos + 1
   until not pos
   return tokens
end

return mod
