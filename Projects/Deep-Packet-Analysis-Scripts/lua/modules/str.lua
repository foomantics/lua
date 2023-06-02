-- Author(s): Jim Lee
-- Last Updated: 02/26/19
-- File Description: Lua module for creating custom string library
-- functions to be called on by NetMon deep packet analysis scripts.
-- This file must live in the NetMon box: "/usr/local/probe/apiLua/usr".
-- Also, this file must have the following ownership and permissions:
-- "-rw-rw-r-- dpi nobody ... str.lua".



-- Create custom string library i.e. 'str'
local str = {}

-- Return string "true"
function str.True()
   return "true"
end

-- Return string "false"
function str.False()
   return "false"
end

-- Check if string argument(s) is nil or has length 0
-- Return boolean true if any condition holds
-- Else, return boolean false
function str.isEmpty(...)
   local n = select('#', ...)
   local strs = {...}

   for i = 1, n do
      if not strs[i] or strs[i] == '' then
         return true
      end
   end

   return false
end

-- Given Lua table argument, return element(s) in table
-- Lua table contians custom metadata field element(s)
-- created by anothwer deep-packet-analysis script
-- If Lua table argument is nil, then return nothing
function str.extractField(ctb)
   if ctb then
      for key, cfield in pairs(ctb) do
         return cfield
      end
   end
end

-- Given country name and code in geoiplookup format
-- e.g. 'US, United States' return only the country code
-- Else, return "null"
function str.formatGeo(geoIP)
   if not str.isEmpty(geoIP) then
      local i, j = geoIP:find(", ")
      if i then
             return geoIP:sub(1, i-1)
      end
   end
end

-- Helper function to get first 4 ASCII characters of MAC
-- that are not colons i.e. formatted OUI
function str.formatOUIs(src, dst)
   local n_cols = 0
   local s_OUI = ""
   local d_OUI = ""

   for i = 1, #src do
      local c_1 = src:sub(i,i)
      local c_2 = dst:sub(i,i)

      s_OUI = s_OUI..c_1
      d_OUI = d_OUI..c_2

      if c_1 == ":" then
         n_cols = n_cols + 1
      end

      if n_cols == 3 then
         return s_OUI:gsub(':', ''), d_OUI:gsub(':', '')
      end
   end
end

-- Given WHOIS domain creation date in python datetime
-- return the creation date in 'year-month-date' format
-- This function is only called if creation date can
-- not be found using string.find(...) pattern matching
-- in the parent function str.findDate(...)
function str.formatDate(wDate)
   local a, b = wDate:find("%d%d%d%d")
   local i, j = wDate:find("%(%d")
   local date = ""

   if a and i then
      local sub_line = wDate:sub(i, i+11)
          local d0, _ = sub_line:gsub("%D+", " ")
          local d1, _ = d0:gsub("% ", "-")
          local p = "-0"

          if d1:find("%-%d%-%d%-") then
         date0 = d1:sub(0, 4)
         date1 = p..d1:sub(6, 6)
         date2 = p..d1:sub(8, 8)
         date = wDate:sub(0, a)..date0..date1..date2
      elseif d1:find("%-%d%-%d%d%-") then
         date0 = d1:sub(0, 4)
         date1 = p..d1:sub(6, 6)
         date2 = d1:sub(7, 9)
         date = wDate:sub(0, a)..date0..date1..date2
      elseif d1:find("%-%d%d%-%d%-") then
         date0 = d1:sub(0, 7)
         date1 = p..d1:sub(9, 9)
         date = wDate:sub(0, a)..date0..date1
      end
   end

   if not str.isEmpty(date) then
      return date
   end
end

-- Given WHOIS domain creation date, return the creation date
-- in this format: 'XXXX-XX-XX' i.e. 'year-month-date' format
-- Else, return nothing if input 'wOut' is nil
function str.findDate(wOut)
   if not str.isEmpty(wOut) then
      local d_format = "%d%d%d%d%-%d%d%-%d%d"
      local i, j = wOut:find(d_format)

      if i then
             return wOut:sub(i, j)
      end

      return str.formatDate(wOut)
   end
end

-- Given a grep output 'gout', look for "_" delimeter
-- and then return line contents following delimeter
-- Return nothing if 'gout' is empty
function str.parseGrep(gOut)
   if gOut then
      for line in io.lines(gOut) do
             local i, j = line:find("_")

         if j then
            return line:sub(j+1)
             end
      end
   end
end

-- Return custom string library
return str
