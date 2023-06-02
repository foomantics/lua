-- Author(s): Jim Lee
-- Last Updated: 04/04/19
-- File Description: Lua module for creating custom TCP packet library
-- functions to be called on by NetMon deep-packet-analysis scripts.
-- This file must live in the NetMon box: "/usr/local/probe/apiLua/usr".
-- Also, this file must have the following ownership and permissions:
-- "-rw-rw-r-- dpi nobody ... http.lua".



-- Import custom CLI and string libraries
local cli = require "cli"
local str = require "str"

-- Create custom HTTP packet library i.e. 'http'
local http = {}

-- Given an HTTP status return code
-- check if it is a valid code
-- i.e. in the following range [100, 599]
function http.validStatusCode(code)
   local code_min = 100
   local code_max = 599
    
   if code_min <= code and code <= code_max then
      return true
   end
   
   return false
end

-- Given a network flow and HTTP method request
-- return a description of the HTTP method request
-- as a custom metadata field of the given network flow
function http.getMethodDescription(request)
   local d = ""

   for r in request:gmatch('([^|]+)') do
      local sub_d = cli.grepTarget(r, "http_methods.txt")
      if not str.isEmpty(sub_d) then
         d = d..sub_d
      end
   end

   return d
end

-- Given a network flow and HTTP status return code
-- return the family that the code belongs to
-- i.e. informational, success, redirection,
-- client-side error, or server-side error
function http.getCodeFamily(code)
   if http.validStatusCode(code) then
      local fam = ""
      local offset = 99
      local f = {100, 200, 300, 400}

      if f[1] <= code and code <= f[1]+offset then
         fam = "informational"
      elseif f[2] <= code and code <= f[2]+offset then
         fam = "success"
      elseif f[3] <= code and code <= f[3]+offset then
         fam = "redirection"
      elseif f[4] <= code and code <= f[4]+offset then
         fam = "client_side_error"
      else
         fam = "server_side_error"
      end

      return fam
   end
end

-- Return custom HTTP packet library
return http
