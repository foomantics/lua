function Is_InternalDNS (dpiMsg, ruleEngine)
   require 'LOG'
   local els = require "els"
   local str = require "str"
   local ipvf = require "ipvf"

   -- Helper function given source and destination IP addresses, return a
   -- boolean string if either IP addresses are '10.10.10.3' or '10.10.10.13'
   local function dnsScope(src, dst)
      local dc0 = "10.0.0.103"
      local dc1 = "10.0.0.203"
      local dns_int = "DNS_Internal"

      if dc0 == src or dc0 == dst or dc1 == src or dc1 == dst then
         return els.setField(dpiMsg, dns_int, str.True())
      end
 
      return els.setField(dpiMsg, dns_int, str.False())
   end

   -- Given DNS network flow, return a custom Elasticsearch field where the
   -- value is a boolean string classifying if DNS flow is internal i.e. a 
   -- DNS query was resolved by either '10.10.10.3' or '10.10.10.13'.   
   local function main()
      if GetLatestApplication(dpiMsg) == 'dns' then
         local src, dst = ipvf.getIP4Strings(dpiMsg)
          
         if not ipvf.isEmpty(src, dst) then
            dnsScope(src, dst)
         end
      end 
   end

   --********* MAIN CHUNK *********--
   main()
end
