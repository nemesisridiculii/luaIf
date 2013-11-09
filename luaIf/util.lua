function ripairs(list)
   if(type(list) ~= "table") then error("ripairs() must be called with a table"); end
   
   return function(x, i) 
      if(i<=1) then return nil end 
      i = i - 1; 
      return i, x[i] 
   end, list, #list+1;
end
