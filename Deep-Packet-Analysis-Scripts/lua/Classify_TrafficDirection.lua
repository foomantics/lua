function Classify_TrafficDirection (dpiMsg, ruleEngine)
   require 'LOG'
   local els = require "els"
   local str = require "str"
   
   -- Helper function given two booleans to describe if either source or 
   -- destination IP is private, classify the direction of a network flow
   local function setTraffDir(src, dst)
      local dir = ""
      local t = str.True()
      local f = str.False()
       
      if src == t and dst == f then
         dir = "egress"
      elseif src == f and dst == t then
         dir = "ingress"
      elseif src == t and dst == t then
         dir = "lateral"
      end
      
      els.setField(dpiMsg, "Traffic_Direction", dir)
   end

   -- Given network flow, return custom Elasticsearch field where the value
   -- classifies the direction of the flow as 'ingress', 'egress', or 'lateral'.
   local function main()
      local s_pr = str.extractField(els.getField(dpiMsg, "SrcIP_Private"))
      local d_pr = str.extractField(els.getField(dpiMsg, "DstIP_Private"))
         
      if not str.isEmpty(s_pr, d_pr) then
         setTraffDir(s_pr, d_pr)
      end
   end
   
   --********* MAIN CHUNK *********--
   main()
end
