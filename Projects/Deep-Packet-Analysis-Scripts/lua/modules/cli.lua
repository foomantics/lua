-- Author(s): Jim Lee
-- Last Updated: 03/18/19
-- File Description: Lua module for creating bash command line interface
-- functions to be called on by NetMon deep-packet-analysis scripts.
-- This file must live in the NetMon box: "/usr/local/probe/apiLua/usr".
-- Also, this file must have the following ownership and permissions:
-- "-rw-rw-r-- dpi nobody ... cli.lua".



-- Import 'str' i.e. custom string library
local str = require "str"

-- Create custom command line interface library i.e. 'cli'
local cli = {}

-- Given a target file 'sFile' and string to be searched for 'target'
-- Perform cat command on 'sFile', then grep 'target' from cat output
-- If 'target' was found in 'sFile', then parse the grep output
-- and return the parsed file line(s)
-- Else, return null if grep output returned nothing
function cli.grepTarget(target, sFile)
   if target and sFile then
      local tmp = os.tmpname()
      local targ_file = "/home/probe/lua/"..sFile
      local cmd = "cat "..targ_file.." | grep '"..target.."' > "..tmp

      os.execute(cmd)
      local cmd_out = str.parseGrep(tmp)
      os.remove(tmp)

      return cmd_out
   end
end

-- Given a IPv4 address, perform geoIP lookup and return
-- the country where the IPv4 address originated from
-- If the IPv4 address is not a public address e.g. LAN address
-- then return the string "IP address not found"
function cli.geoLookup(ip)
   local tmp = os.tmpname()
   local filter = "\"GeoIP Country Edition: \\K.*\""
   local cmd = "geoiplookup "..ip.." | grep -oP "..filter.." > "..tmp
   local cmd_out = "null"

   os.execute(cmd)
   for line in io.lines(tmp) do
      if line then
         cmd_out = line
      end
   end
   os.remove(tmp)

   return cmd_out
end

-- Given a domain in 2LD representation e.g. 'example.com'
-- perform WHOIS lookup with this domain and find the
-- registration date to return to calling DPA
function cli.getRegDate(dom)
   local tmp = os.tmpname()
   local cmd = "python /home/probe/lua/getRegDate.py "..dom.." > "..tmp
   local cmd_out = ""

   os.execute(cmd)
   for line in io.lines(tmp) do
          if line then
             cmd_out = str.findDate(line)
      end
   end
   os.remove(tmp)

   return cmd_out
end

-- Return bash command line interface library
return cli
