function ReservedIP_Lookup (dpiMsg, ruleEngine)
   require 'LOG'
   require 'IPv4LanDefine'
   local els = require "els"
   local str = require "str"
   local ipvf = require "ipvf"

   -- Global function variables for defining IANA IPv4 Special-Purpose 
   -- Address Ranges
   local addr_r0 = IPv4LanDefine:new('0.0.0.0', '0.255.255.255')
   local addr_r1 = IPv4LanDefine:new('100.64.0.0', '100.127.255.255')
   local addr_r2 = IPv4LanDefine:new('127.0.0.0', '127.255.255.255')
   local addr_r3 = IPv4LanDefine:new('169.254.0.0', '169.254.255.255')
   local addr_r4 = IPv4LanDefine:new('192.0.0.1', '192.0.0.7')
   local addr_r5 = IPv4LanDefine:new('192.0.0.8', '192.0.0.8')
   local addr_r6 = IPv4LanDefine:new('192.0.0.9', '192.0.0.9')
   local addr_r7 = IPv4LanDefine:new('192.0.0.10', '192.0.0.10')
   local addr_r8 = IPv4LanDefine:new('192.0.0.11', '192.0.0.255')
   local addr_r9 = IPv4LanDefine:new('192.0.0.170', '192.0.0.171')
   local addr_r10 = IPv4LanDefine:new('192.0.2.0', '192.0.2.255')
   local addr_r11 = IPv4LanDefine:new('192.31.196.0', '192.31.196.255')
   local addr_r12 = IPv4LanDefine:new('192.52.193.0', '192.52.193.255')
   local addr_r13 = IPv4LanDefine:new('192.175.48.0', '192.175.48.255')
   local addr_r14 = IPv4LanDefine:new('198.18.0.0', '198.19.255.255')
   local addr_r15 = IPv4LanDefine:new('198.51.100.0', '198.51.100.255')
   local addr_r16 = IPv4LanDefine:new('203.0.113.0', '203.0.113.255')
   local addr_r17 = IPv4LanDefine:new('224.0.0.0', '239.255.255.255')
   local addr_r18 = IPv4LanDefine:new('255.255.255.255', '255.255.255.255')
   
   -- Helper function given an IP address and custom Elasticsearch field name
   -- to assign a description of the reserved IP address block for the IP
   -- address if it exists
   local function getReservedIP(ip, fName)
      -- Reserved IP Purpose                  Begin             End
      -- ----------------------------------------------------------------------
      -- "This" Network                       0.0.0.0           0.255.255.255
      -- Shared Address Space                 100.64.0.0        100.127.255.255
      -- Loopback                             127.0.0.0         127.255.255.255
      -- Link-Local                           169.254.0.0       169.254.255.255
      -- IETF Protocol Assignments            192.0.0.1         192.0.0.255
      -- IPv4 Service Continuity Prefix       192.0.0.1         192.0.0.7
      -- IPv4 Dummy Address                   192.0.0.8         n/a
      -- Port Control Protocol Anycast        192.0.0.9         n/a 
      -- Traversal Using Relays around        ...               ...
      -- NAT Anycast                          192.0.0.10        n/a
      -- NAT64/DNS64 Discovery                192.0.0.170       192.0.0.171
      -- Test-Net-1                           192.0.2.0         192.0.2.255
      -- AS112-v4                             192.31.196.0      196.31.196.255
      -- AMT                                  192.52.193.0      192.52.193.255
      -- Direct Delegation AS112 Service      192.175.48.0      192.175.48.255
      -- Benchmark Testing                    198.18.0.0        198.19.255.255
      -- Test-Net-2                           198.51.100.0      198.51.100.255
      -- Test-Net-3                           203.0.113.0       203.0.113.255
      -- Multicast                            224.0.0.0         239.255.255.255
      -- Limited Broadcast                    255.255.255.255   255.255.255.255

      local resIP = ""
      if addr_r0:IsInLan(ip) then
         resIP = "this_network"
      elseif addr_r1:IsInLan(ip) then
         resIP = "shared_address_space"
      elseif addr_r2:IsInLan(ip) then
         resIP = "loopback"
      elseif addr_r3:IsInLan(ip) then
         resIP = "link_local"
      elseif addr_r4:IsInLan(ip) then
         resIP = "ipv4_service_continuity_prefix"
      elseif addr_r5:IsInLan(ip) then
         resIP = "ipv4_dummy_address"
      elseif addr_r6:IsInLan(ip) then
         resIP = "port_control_protocol_anycast"
      elseif addr_r7:IsInLan(ip) then 
         resIP = "nat_anycast"
      elseif addr_r8:IsInLan(ip) then
         resIP = "ietf_protocol_assignments"
      elseif addr_r9:IsInLan(ip) then
         resIP = "nat64_dns64_discovery"
      elseif addr_r10:IsInLan(ip) then
         resIP = "test_network_1"
      elseif addr_r11:IsInLan(ip) then
         resIP = "as112_v4"
      elseif addr_r12:IsInLan(ip) then
         resIP = "amt"
      elseif addr_r13:IsInLan(ip) then
         resIP = "direct_delegation_as112_service"
      elseif addr_r14:IsInLan(ip) then 
         resIP = "benchmark_testing"
      elseif addr_r15:IsInLan(ip) then
         resIP = "test_network_2"
      elseif addr_r16:IsInLan(ip) then
         resIP = "test_network_3" 
      elseif addr_r17:IsInLan(ip) then
         resIP = "multicast"
      elseif addr_r18:IsInLan(ip) then
         resIP = "limited_broadcast"
      end
      
      els.setField(dpiMsg, fName, resIP)
   end

   -- Given a network flow, return custom Elasticsearch fields where the values
   -- classify the IP addresses as special purpose e.g. return 'multicast' for
   -- the IP address '224.0.0.251'.
   local function main()
      if ipvf.validIPs(dpiMsg) then
         local src, dst = ipvf.getIP4Ints(dpiMsg)
         
         if not ipvf.isEmpty(src, dst) then 
            getReservedIP(src, "Src_ReservedIP")
            getReservedIP(dst, "Dst_ReservedIP")
         end
      end
   end

   --*********-- MAIN CHUNK --*********--
   main()
end
