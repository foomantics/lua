-- Author(s): Jim Lee
-- Last Updated: 04/02/19
-- File Description: Lua module for creating custom Elasticsearch
-- functions to be called on by NetMon deep-packet-analysis scripts.
-- This file must live in the NetMon box: "/usr/local/probe/apiLua/usr".
-- Also, this file must have the following ownership and permissions:
-- "-rw-rw-r-- dpi nobody ... els.lua".



-- Import custom CLI and string libraries
local cli = require "cli"
local str = require "str"

-- Create custom Elasticsearch library i.e. 'els'
local els = {}

-- Given a name for a custom metadata field and Elasticsearch index
-- return the indexed value within the network flow if it exists
function els.getField(flow, key)
   local val = GetCustomField(flow, key)
   
   if not str.isEmpty(val) then
      return val 
   end
end

-- Given a name for a custom metadata field and string value
-- create custom Elasticsearch indexing with key as
-- custom field name and value to the string value parameter
function els.setField(flow, key, val)
   if flow and not str.isEmpty(key, val) then
      SetCustomField(flow, key, val)
   end   
end

-- Given a pattern, lookup text file, and a name for a custom
-- metadata field, grep the lookup file for the pattern and
-- set the custom field to the grep result with the field name
-- No return value
function els.setLookupField(flow, target, tFile, fName)
   if not str.isEmpty(flow, target, tFile, fName) then
      local res = cli.grepTarget(target, tFile)
      if res then
         els.setField(flow, fName, res)
      end
   end
end

-- Return custom Elasticsearch library
return els
