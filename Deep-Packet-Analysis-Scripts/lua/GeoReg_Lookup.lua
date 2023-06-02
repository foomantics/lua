function GeoReg_Lookup (dpiMsg, ruleEngine)
   require 'LOG'
   local els = require "els"
   local str = require "str"

   -- Helper function given formatted geoiplookup, lookup file, and custom 
   -- Elasticsearch field name, set a custom field value with subregion 
   -- associated with a country
   local function setReg(geoFmt, tFile, fName)
      if not str.isEmpty(geoFmt) then
         els.setLookupField(dpiMsg, geoFmt, tFile, fName) 
      end
   end

   -- Helper function given geoIP lookups for source and IP addresses, format
   -- geoiplookup output and return the associated broader subregion
   local function subRegs(srcGeo, dstGeo)
      local t_file = "geo_codes.txt"
      setReg(str.formatGeo(srcGeo), t_file, "SrcIP_GeoRegion")
      setReg(str.formatGeo(dstGeo), t_file, "DstIP_GeoRegion")
   end 

   -- Given any network flow, return a custom Elasticsearch field where the
   -- value is the broader subregion associated with a GeoIP lookup e.g. return
   -- 'Northern America' for 'US, United States'.
   local function main()   
      local s_gl = els.getField(dpiMsg, "SrcIP_GeoLookup")
      local d_gl = els.getField(dpiMsg, "DstIP_GeoLookup")
      subRegs(str.extractField(s_gl), str.extractField(d_gl))
   end

   --*********-- MAIN CHUNK --*********--
   main()
end
