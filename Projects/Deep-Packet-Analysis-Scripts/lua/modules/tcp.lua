-- Author(s): Jim Lee
-- Last Updated: 07/19/19
-- File Description: Lua module for creating custom TCP packet library
-- functions to be called on by NetMon deep-packet-analysis scripts.
-- This file must live in the NetMon box: "/usr/local/probe/apiLua/usr".
-- Also, this file must have the following ownership and permissions:
-- "-rw-rw-r-- dpi nobody ... tcp.lua".



-- Create custom TCP packet library i.e. 'tcp'
local tcp = {}

-- Return source and destination port numbers as ints
function tcp.getPortInts(flow)
   local prot = "Internal"
   return GetInt(flow, prot, "srcport"), GetInt(flow, prot, "destport")
end

-- Check if given port numbers is a valid port number i.e.
-- within the following range [0, 65535]
-- Return true if condition above holds, else false
function tcp.validPorts(sport, dport)
   local min = 0
   local max = 65535

   return (min <= sport and sport <= max) and (min <= dport and dport <= max)
end

-- Given valid port number, return the type a port number belongs to
-- i.e. well-known, user/registered, and dynamic/private
function tcp.getPortType(port)
   local b0 = 0
   local b1 = 1023
   local b2 = 49151
   local p_type = ""

   if b0 <= port and port <= b1 then
      p_type = "well_known"
   elseif b1+1 <= port and port <= b2 then
      p_type = "registered"
   else
      p_type = "ephemeral"
   end

   return p_type
end

-- Return custom TCP packet library
return tcp
