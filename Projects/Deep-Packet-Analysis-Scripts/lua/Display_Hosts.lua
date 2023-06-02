function Display_Hosts (dpiMsg, ruleEngine)
   require 'LOG'
   local els = require "els"
   local str = require "str"
   local ipvf = require "ipvf"

   -- Given any network flow, extract the MAC addresses from the Ethernet 
   -- header and return custom Elasticsearch fields where the values are the 
   -- host name (not formally assigned) associated to the MAC addresses.
   local function main()
      local src, dst = ipvf.getMacStrings(dpiMsg)
      
      if not str.isEmpty(src, dst) then
         local t_file = "hba_hosts.txt"
         els.setLookupField(dpiMsg, src, t_file, "SrcIP_Host_ID")
         els.setLookupField(dpiMsg, dst, t_file, "DstIP_Host_ID")
      end
   end

   --********* MAIN CHUNK *********--
   main()
end
