function RegDate_Lookup (dpiMsg, ruleEngine)
   require 'LOG'
   local els = require "els"
   local str = require "str"
   
   -- Given a domain in second level representaiton e.g. 'haightbey.com'
   -- create a custom metadata field for its associated registration date
   local function main()
      if GetLatestApplication(dpiMsg) == 'dns' then
         local q_dom = str.extractField(els.getField(dpiMsg, "Query_2LD"))
         
         if not str.isEmpty(q_dom) and not q_dom:find(".local") then
            els.setLookupField(dpiMsg, dom, "myDates.txt", "Registration_Date")
         end
      end
   end
   
   --*********-- MAIN CHUNK --*********--
   main()
end
