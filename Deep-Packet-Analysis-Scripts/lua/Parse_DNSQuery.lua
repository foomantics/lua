function Parse_DNSQuery_Ref (dpiMsg, ruleEngine)
   require 'LOG'
   local dns = require "dns"
   local els = require "els"
   local str = require "str"

   -- Given queried domain(s) parse the domain to the second-level
   -- representation 
   local function setParsedDoms(doms)
      local s_dom, p_doms = dns.parseDoms(doms)
      
      if s_dom then
         return els.setField(dpiMsg, "Query_2LD", p_doms) 
      end
      
      for i, d in ipairs(p_doms) do
         els.setField(dpiMsg, "Query_2LD", d) 
      end
   end

   -- Given DNS network flow, create a custom Elasticsearch field where the 
   -- value is the second-level representation of the default 'Query' field
   -- e.g. return 'example.com' for 'www.example.com'.
   local function main() 
      local dns_str = "dns"
      if HasApplication(dpiMsg, dns_str) then
         local q_dom = GetString(dpiMsg, dns_str, "query") 
         
         if not str.isEmpty(q_dom) then
            setParsedDoms(q_dom)
         end
      end 
   end
   
   --********* MAIN CHUNK *********--
   main() 
end
