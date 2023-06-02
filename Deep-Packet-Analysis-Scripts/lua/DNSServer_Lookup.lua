function DNSServer_Lookup (dpiMsg, ruleEngine)
   require 'LOG'
   local els = require "els"
   local str = require "str"

   -- Helper function given an Elasticsearch custom field name and public DNS
   -- server IP, return the organization name associated with the IP
   local function setDNSName(fName, publicDNS)
      els.setLookupField(dpiMsg, publicDNS, "public_dns_names.txt", fName)
   end

   -- Given DNS network flow, create a custom Elasticsearch field where the 
   -- value is the organization name associated with a public DNS server
   -- e.g. return 'Google' for '8.8.8.8'.
   local function main()
      if HasApplication(dpiMsg, "dns") then
         local src_priv = str.extractField(els.getField(dpiMsg, "SrcIP_Private"))
         local dst_priv = str.extractField(els.getField(dpiMsg, "DstIP_Private"))
          
         if src_priv == "true" and dst_priv == "false" then 
            setDNSName("Public_DNS_Name", GetDstIP4String(dpiMsg))
         end
      end 
   end

   --********* MAIN CHUNK *********--
   main()
end
