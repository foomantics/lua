function Find_New_Obs_Doms (dpiMsg, ruleEngine)
   require 'LOG'
   

   -- Helper function to return only element in 'custom_tb' 
   local function GetDom(custom_tb) 
      if custom_tb == nil then return end  
       
      for k,v in pairs(custom_tb) do
         return v 
      end 
   end

   -- Helper function to count number of levels (periods) in a domain query
   local function CountLvls(str) 
     local count = 0 
      
     for i = 1, #str do
        if str:sub(i,i) == "." then count = count + 1 end 
     end
     return count 
   end  

   -- Helper function to ignore deepest level of Query_SL_NM
   local function NextLvl(str) 
      for i = 1, #str do
         if str:sub(i,i) == "." then return string.sub(str, i+1) end 
      end 
   end 
 
   -- Helper function to parse the date of WHOIS query (partial)
   local function ParseDate(str)
      i,j = string.find(str, "%d%d%d%d") 
      
      if i~=nil and j~=nil then
         local m,n = string.find(str, "%-%d%d%-%d%d")
         if m~=nil and n~= nil then return string.sub(str, i, j)..string.sub(str, m,n) end      
         
         m,n = string.find(str, "%/%d%d%/%d%d")
         if m~=nil and n~= nil then return string.sub(str, i, j)..string.sub(str, m,n) end      
         
         m,n = string.find(str, "%d%d%. %d%d%.")
         if m~=nil and n~= nil then return string.sub(str, i, j)..". "..string.sub(str, m,n) end     
         
         m,n = string.find(str, "%d%d%-%a%a%a")
         if m~=nil and n~= nil then return string.sub(str, i, j).."-"..string.sub(str, m,n) end      
         
         m,n = string.find(str, "%a%a%a %d%d")
         if m~=nil and n~= nil then return string.sub(str, i, j).." "..string.sub(str, m, n) end      
      end 
   end 

   -- Helper function to extract date from WHOIS query
   function ParseQuery(file) 
      if file == nil then
         return 
      else
         for line in io.lines(file) do
            local reg_date = ParseDate(line)

            if reg_date ~= nil then return reg_date end
         end 
      end
   end
   -- Helper function to parse a WHOIS query
   local function Whois(dom)
      -- Execute WHOIS query
      local tmp = os.tmpname()
      local whois_q = "whois "..dom.. " | grep 'Creat|creat|Registered|Registration Date' > "..tmp
      os.execute(whois_q)
   
      -- Extract date from WHOIS query
      local reg_date = ParseQuery(tmp, dom) 
      local lvls = CountLvls(dom)
      os.remove(tmp)

      -- Perform additional WHOIS query if more than one level in domain
      if reg_date == nil and lvls == 1 then
         return nil    
      elseif reg_date == nil and lvls > 1 then
         return Whois(NextLvl(dom)) 
      end
      return reg_date
   end

   -- Helper function to search for the most recently queried domain in 
   -- 'queried_doms.txt', a dynamic file containing previously queried domains
   local function FindDom(msg, dom, doms_file)
       
      -- Exit if 'cand_dom' already exists in 'queried_doms.txt' 
      for line in doms_file:lines() do 
         if line == dom then
            --INFO(debug.getinfo(1, "S"), cand_dom.." has been previously queried.")
            SetCustomField(msg, "Previously_Queried", "True") 
            doms_file:close() 
            return
         end
      end
      
      -- Append 'cand_dom' to 'queried_doms.txt' 
      doms_file:write(dom.."\n") 
      doms_file:close()  
      os.execute("cat /home/probe/lua/queried_doms.txt | sort > /my-path/sorted_queried_doms.txt")

      -- Execute WHOIS query to find registration date
      local reg_date = Whois(dom)
      if reg_date ~= nil then
         local dwd_file = assert(io.open("/my-path/doms_w_dates.txt", "a+"))
         dwd_file:write(dom.."_"..reg_date.."\n")
         dwd_file:close() 
      end 

      --INFO(debug.getinfo(1, "S"), cand_dom.." is a new queried domain.")
      SetCustomField(dpiMsg, "Previously_Queried", "False")
   end 
  
   if GetLatestApplication(dpiMsg) == 'dns' then
      local q_doms_tb = GetCustomField(dpiMsg, "Query_SL")  
      local cand_dom = GetDom(q_doms_tb)
      if cand_dom == nil then return end 
      
      local q_doms_file = assert(io.open("/my-path/queried_doms.txt", "a+"))
      FindDom(dpiMsg, cand_dom, q_doms_file)
   end 
end
