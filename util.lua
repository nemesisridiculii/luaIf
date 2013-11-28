function ripairs(list)
   if(type(list) ~= "table") then error("ripairs() must be called with a table"); end
   
   return function(x, i) 
      if(i<=1) then return nil end 
      i = i - 1; 
      return i, x[i] 
   end, list, #list+1;
end

function capitalize(x)
   if(type(x) ~= "string") then error("capitalize must be called on a string"); end
   
   return x:sub(1, 1):upper()..x:sub(2);
end


function tableappend(tab, ...)
   local vals = {...};
   for i,v in ipairs(vals) do
      tab[#tab+1] = v;
   end
end