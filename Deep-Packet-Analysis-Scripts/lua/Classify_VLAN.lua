function Classify_VLAN (dpiMsg, ruleEngine)
   require 'LOG'
   require 'IPv4LanDefine'
   local els = require "els"
   local str = require "str"
   local ipvf = require "ipvf"

   -- Global function variables for defining VLANs
   local vl_0 = IPv4LanDefine:new('192.168.0.1', '192.168.0.255')
   local vl_1 = IPv4LanDefine:new('172.16.0.1', '172.16.0.255')
   local vl_2 = IPv4LanDefine:new('10.0.0.1', '10.0.0.255')
   
   -- Helper function to take an LAN IP address and custom Elasticsearch field
   -- name, then assign a VLAN ID to the Elasticsearch field value
   local function getVLAN(ip, fName)
      -- Currently the VLAN ranges are defined as:
      -- VLAN ID                  Begin             End
      -- -------------------------------------------------------
      -- Dummy VLAN #1            192.168.0.1       192.168.0.255
      -- Dummy VLAN #2            172.16.0.1        172.16.0.255
      -- Dummy VLAN #3            10.0.0.1          10.0.0.255
      
      local vlan = ""
      if vl_0:IsInLan(ip) then
         vlan = "dummy_vl_0"
      elseif vl_1:IsInLan(ip) then
         vlan = "dummy_vl_1"
      elseif vl_2:IsInLan(ip) then
         vlan = "dummy_vl_2"
      end
      
      els.setField(dpiMsg, fName, vlan)
   end

   -- Given a network flow with IPv4 addresses in a LAN, return the VLAN ID
   -- that each LAN IP address belongs to.
   local function main()
      if ipvf.validIPs(dpiMsg) then
         local src, dst = ipvf.getIP4Ints(dpiMsg)
         
         if not ipvf.isEmpty(src, dst) then 
            getVLAN(src, "Src_VLAN")
            getVLAN(dst, "Dst_VLAN")
         end
      end
   end

   --*********-- MAIN CHUNK --*********--
   main()
end