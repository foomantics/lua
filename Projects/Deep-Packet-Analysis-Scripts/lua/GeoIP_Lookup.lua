function GeoIP_Lookup (dpiMsg, ruleEngine)
   require 'LOG'
   local els = require "els"
   local cli = require "cli"
   local ipvf = require "ipvf"

   -- Helper function given a custom Elasticsearch field name and GeoIP output,
   -- set the field value to the origin country associated with an IP address
   local function setGeo(fName, geo)
      if ipvf.geoFound(geo) then
         els.setField(dpiMsg, fName, geo) 
      end
   end

   -- Given any network flow, create custom Elasticsearch fields where the
   -- values are GeoIP outputs for public IPv4 addresses e.g. return
   -- 'US, United States' for '8.8.8.8'.
   local function main()
      if ipvf.validIPs(dpiMsg) then
         local srcIP, dstIP = ipvf.getIP4Strings(dpiMsg)
         
         if not ipvf.isEmpty(srcIP, dstIP) then
            local src, dst = ipvf.isNonRout(srcIP, dstIP)
            setGeo("SrcIP_GeoLookup", cli.geoLookup(src))
            setGeo("DstIP_GeoLookup", cli.geoLookup(dst))
         end
      end 
   end

   --*********-- MAIN CHUNK --*********--
   main()
end
