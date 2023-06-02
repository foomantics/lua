function Method_Lookup (dpiMsg, ruleEngine)
   require 'LOG'
   local els = require "els"
   local str = require "str"
   local http = require "http"

   -- Given HTTP network flow, create a custom Elasticsearch field where the
   -- value is a description of a HTTP request method e.g. return 'Request data
   -- from server with URL parameters.' for method request 'GET'.
   local function main()
      local http_str = "http"
      if HasApplication(dpiMsg, http_str) then
         local req = GetString(dpiMsg, http_str, "method")

         if not str.isEmpty(req) then
            els.setField(dpiMsg, "Method_Lookup", http.getMethodDescription(req))
         end
      end
   end

   --*********-- MAIN CHUNK --*********--
   main()
end
