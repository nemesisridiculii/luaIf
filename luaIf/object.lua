
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
   if(mt == nil) then return nil; end
   return mt.__index;
end


function Object:match(tokens)
  if(self.name == nil) then return false; end

  local found;

  --TODO: this is O(n^2) can we do better?
  for j,t in ipairs(tokens) do
    found = false;
    for i,n in ipairs(self.name) do
      if(n == t) then found=true; break; end
    end
    if(found == false) then return false; end
  end

  return true;
end

function Object:placeIn(obj)
   if(self.contains == nil) then self.contains = {}; end

   self.contains[#self.contains+1] = obj;
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

   return Person:parent().isA(self, testtype);
end


------------------------
Room = Object:new();

function Room:isA(testtype)
   if(testtype == Room) then return true; end
   if(type(testtype) == "string") then
      if(string.lower(testtype) == "room") then return true; end
   end

   return Room:parent().isA(self, testtype);
end
