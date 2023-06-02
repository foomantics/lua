function Is_PrivateIP (dpiMsg, ruleEngine)
   require 'LOG'
   require 'IPv4LanDefine'
   local els = require "els"
   local str = require "str"
   local ipvf = require "ipvf"

   -- Global function variables for defining private IP ranges
   local pr_0 = IPv4LanDefine:new('10.0.0.0', '10.255.255.255')
   local pr_1 = IPv4LanDefine:new('192.168.0.0', '192.168.255.255')
   local pr_2 = IPv4LanDefine:new('172.16.0.0', '172.31.255.255')

   -- Helper function given source and destination IPv4 addresses, return a
   -- boolean string to classify the IPv4 addresses as either private or 
   -- not private
   local function isPrivIP(src, dst)
      local src_is_priv = pr_0:IsInLan(src) or pr_1:IsInLan(src)
         or pr_2:IsInLan(src)

      local dst_is_priv = pr_0:IsInLan(dst) or pr_1:IsInLan(dst)
         or pr_2:IsInLan(dst)
        
      els.setField(dpiMsg, "SrcIP_Private", tostring(src_is_priv))
      els.setField(dpiMsg, "DstIP_Private", tostring(dst_is_priv))
   end

   -- Given any network flow, create a custom Elasticsearch field where the
   -- value is a boolean string classifying the IPv4 addresses as either 
   -- private or not private e.g. return 'true' for '10.0.0.1'.
   local function main()
      if ipvf.validIPs(dpiMsg) then 
         local src, dst = ipvf.getIP4Ints(dpiMsg)
          
         if not ipvf.isEmpty(src, dst) then 
            isPrivIP(src, dst)
         end
      end
   end

   --*********-- MAIN CHUNK --*********--
   main()
end
