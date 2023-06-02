function Port_Type (dpiMsg, ruleEngine)
   require 'LOG'
   local els = require "els"
   local tcp = require "tcp"

   -- Given any network flow, return custom Elasticsearch fields where the 
   -- values classify the source and destination port numbers e.g. '80' 
   -- belongs to 'well_known' and '1024' belongs to 'registered'.
   local function main()
      local s_port, d_port = tcp.getPortInts(dpiMsg)
         
      if tcp.validPorts(s_port, d_port) then
         els.setField(dpiMsg, "SrcPort_Type", tcp.getPortType(s_port))
         els.setField(dpiMsg, "DstPort_Type", tcp.getPortType(d_port))
      end 
   end

   --********* MAIN CHUNK *********--
   main()
end
