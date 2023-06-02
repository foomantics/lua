function Is_EmotetQuery (dpiMsg, ruleEngine)
   require 'LOG'
   local els = require "els"
   local str = require "str"
   
   -- Helper function given a second-level domain, return whether the domain
   -- potentially matches the Emotet query signature
   local function isEmotet(qDom)
      local dom, tld = qDom:match("(.*)%.(.*)")

      if not str.isEmpty(dom) then 
         if dom:len() == 16 and tld == "eu" then
            TriggerUserAlarm(dpiMsg, ruleEngine, "high")
         end
      end
   end

   -- Given DNS network flow, return an Elasticsearch event alarm if the
   -- second-level representation of the queried domain is 16 characters long
   -- and ends with a top level domain of 'eu' i.e. the Emotet query signature.
   local function main()
      if GetLatestApplication(dpiMsg) == 'dns' then
         local q_dom = str.extractField(els.getField(dpiMsg, "Query_2LD"))
         
         if not str.isEmpty(q_dom) then
            isEmotet(q_dom)
         end
      end
   end
   
   --********* MAIN CHUNK *********--
   main()
end
