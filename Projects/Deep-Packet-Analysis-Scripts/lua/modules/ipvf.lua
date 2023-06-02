-- Author(s): Jim Lee
-- Last Updated: 03/18/19
-- File Description: Lua module for creating custom IPv4 library
-- functions to be called on by NetMon deep-packet-analysis scripts.
-- This file must live in the NetMon box: "/usr/local/probe/apiLua/usr".
-- Also, this file must have the following ownership and permissions:
-- "-rw-rw-r-- dpi nobody ... ipvf.lua".



-- Create custom IPv4 library i.e. 'ipvf'
local ipvf = {}

-- Return source and destination IPv4 addresses as strings
function ipvf.getIP4Strings(flow)
   return GetSrcIP4String(flow), GetDstIP4String(flow)
end

-- Return source and destination IPv4 addresses as ints
function ipvf.getIP4Ints(flow)
   return GetSrcIP4Int(flow), GetDstIP4Int(flow)
end

-- Return source and destination MAC addresses as strings
function ipvf.getMacStrings(flow)
   return GetSrcMacString(flow), GetDstMacString(flow)
end

-- Check if given network flow does not have IPv6 addresses
-- Return true if condition above holds, else false
function ipvf.validIPs(flow)
   return IsSrcIP6(flow) ~= 1 and IsDstIP6(flow) ~= 1
end

-- Check if given geoiplookup is an unknown answer
-- i.e. "IP Address not found" or "null"
-- Return false if condition above holds, else false
function ipvf.geoFound(geo)
   return geo ~= "IP Address not found" and geo ~= "null"
end

-- Check if IPv4 address(es), passed in as int or string
-- date type is valid i.e. not null or greater than 0
-- Return boolean true if any condition holds
-- Else, return boolean false
function ipvf.isEmpty(...)
   local n = select('#', ...)
   local ips = {...}

   for i = 1, n do
      if not ips[i] then
             return true
          end
   end

   return false
end

-- Check if source and destination IPv4 addreses are
-- are "0.0.0.0" i.e. non-routable IPv4
-- Return dummy IP if "0.0.0.0" found
-- Else, return original IP
function ipvf.isNonRout(sIP, dIP)
   local n_rout = "0.0.0.0"
   local dmy_IP = "0.1.2.3"

   if sIP ~= n_rout and dIP == n_rout then
      return sIP, dmy_IP
   elseif sIP == n_rout and dIP ~= n_rout then
      return dmy_IP, dIP
   elseif sIP == n_rout and dIP == n_rout then
      return dmy_IP, dmy_IP
   end

   return sIP, dIP
end

-- Return custom IPv4 library
return ipvf
