function OUI_Lookup (dpiMsg, ruleEngine)
   require 'LOG'
   local els = require "els"
   local str = require "str"
   local ipvf = require "ipvf"
   
   -- Helper function given source and destination MAC addresses, return
   -- the associated OUI strings if they exist in 'oui_formatted.txt'
   local function GetOUIs(src, dst)
      local t_file = "oui_formd.txt"
      local s_mac, d_mac = str.formatOUIs(src, dst)

      els.setLookupField(dpiMsg, s_mac, t_file, "SrcIP_MAC_OUI")
      els.setLookupField(dpiMsg, d_mac, t_file, "DstIP_MAC_OUI")
   end

   -- Given any network flow, create a custom Elasticsearch field where the 
   -- value is the organizationally unique identifier (OUI) associated with
   -- the MAC addresses extracted from the Ethernet header e.g. return
   -- 'Dell Inc.' for MAC address '00:26:B9'.
   local function main()
      local src, dst = ipvf.getMacStrings(dpiMsg)
      
      if not str.isEmpty(src, dst) then
         GetOUIs(src, dst)
      end
   end

   --********* MAIN CHUNK *********--
   main()
end
