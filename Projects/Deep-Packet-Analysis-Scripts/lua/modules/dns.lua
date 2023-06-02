-- Author(s): Jim Lee
-- Last Updated: 04/04/19
-- File Description: Lua module for creating custom DNS packet library
-- functions to be called on by NetMon deep-packet-analysis scripts.
-- This file must live in the NetMon box: "/usr/local/probe/apiLua/usr".
-- Also, this file must have the following ownership and permissions:
-- "-rw-rw-r-- dpi nobody ... dns.lua".



-- Import custom CLI and string libraries
local cli = require "cli"
local str = require "str"

-- Create custom HTTP packet library i.e. 'http'
local dns = {}

-- Helper function to count number of levels (periods) in a DNS query 
function dns.countLvls(s) 
   local _, count = s:gsub("%.", "")
   return count 
end 
    
-- Helper function to find level preceeding top level (find second 
-- to last period); go to third level if top level is country code 
function dns.prevLvl(s, idx) 
   for i = idx, #s do
      if s:sub(i,i) == "." then
         if idx == 4 then 
            return dns.prevLvl(s, i+1)
         else 
            return i-1
         end 
      end
   end 
end 
   
-- Helper function to parse domain after verifying protocol
-- "abc.com" --> "abc.com"
-- "l_n.l_n-1. ... .abc.com" --> "abc.com"
function dns.getDom(dom)
   local count = dns.countLvls(dom)
    
   if count <= 1 then
      return dom
   end
     
   local dom_rev = dom:reverse()
   local i, j = dom_rev:find("%.")
   local secondlvl = dns.prevLvl(dom_rev, j+1)
         
   if not secondlvl then 
      i, j = dom:find("%.")
      return dom:sub(i+1)
   end 
      
   return dom:sub(dom:len() - secondlvl+1)
end

-- Helper function to parse domain(s) in 'Query' metdata field
-- If more than one domain is found, then parse each domain in
-- 'Query' metadata field. Else, parse 'Query' only once.
-- Return pair containing bool and either a string or list of strings
-- The bool indicates whether single parsed domain was returned
function dns.parseDoms(doms)
   if not doms:find("|") then
      return true, dns.getDom(doms)
   end

   local p_doms = {}
   for d in doms:gmatch('[^|]+') do
      table.insert(p_doms, dns.getDom(d))
   end

   return false, p_doms
end

-- Return custom DNS packet library
return dns
