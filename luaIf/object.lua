
Object = {};

function Object:new(x)
   x = x or {};
   local mt = {__index = self};
   setmetatable(x, mt);
   return x;
end

function Object:isA(testtype)
   if(testtype == Object) then return true; end
   if(type(testtype) == "string") then
      if(string.lower(testtype) == "object") then return true; end
   end

   return false;
end

function Object:parent()
   local mt = getmetatable(self);
   return mt.__index;
end


----------------------------
Thing = Object:new();

function Thing:isA(testtype)
   if(testtype == Thing) then return true; end
   if(type(testtype) == "string") then
      if(string.lower(testtype) == "thing") then return true; end
   end

   return Thing:parent().isA(self, testtype);
end



-----------------------------
Person = Object:new();

function Person:isA(testtype)
   if(testtype == Person) then return true; end
   if(type(testtype) == "string") then
      if(string.lower(testtype) == "person") then return true; end
   end

   return Person.parent().isA(self, testtype);
end
