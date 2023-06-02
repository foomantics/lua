function Code_Lookup (dpiMsg, ruleEngine)
   require 'LOG'
   local els = require "els"
   local http = require "http"

   -- Helper function given custom Elasticsearch field name and HTTP status
   -- response code, return the description associated with the code
   local function setDescription(fName, retCode)
      if retCode then
         els.setField(dpiMsg, fName, http.getCodeDescription(retCode))
      end 
   end

   -- Given HTTP network flow, create a custom Elasticsearch field where the 
   -- value classifies the description registered by IETF Review of a status
   -- response code e.g. return 'OK' for status code '200'.
   local function main()
      if HasApplication(dpiMsg, "http") then
         setDescription("Code_Lookup", GetInt(dpiMsg, "http", "code"))
      end
   end

   --********* MAIN CHUNK *********--
   main()
end
