
Object = {
   pronoun = "the";
};

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

function Object:placeOn(obj)
   if(self.supports == nil) then self.supports = {}; end

   self.supports[#self.supports+1] = obj;
end

function Object:describe(contentsLevel, supportsLevel, curlevel)
   contentsLevel = contentsLevel or 1;
   supportsLevel = supportsLevel or 2;
   
   if(curlevel) then curlevel = curlevel.."  "; else curlevel = ""; end

   if(self.short) then io.write(curlevel, capitalize(self.short), "\n"); end
   if(self.desc) then io.write(curlevel, self.desc, "\n"); end
   if(contentsLevel > 0 
      and type(self.contains) == "table" and #self.contains > 0
      and (self == current.room or self.open or self.transparent)
   ) then
      if(self.short) then
	 io.write("\n", curlevel, "In ", self.pronoun, " ", self.short, " is:\n");
      else
	 io.write("\n", curlevel, "Inside is:\n");
      end
      for i,x in ipairs(self.contains) do
	 x:shortDescribe(true, contentsLevel-1, supportsLevel-1, curlevel);
      end
   end

   if(supportsLevel > 0 and type(self.supports) == "table" and #self.supports > 0) then
      if(self.short) then
	 io.write("\n", curlevel, "On, ", self.pronoun, " ", self.short, " is:\n");
      else
	 io.write("\n", curlevel, "On it is:\n");
      end
      for i,x in ipairs(self.supports) do
	 x:shortDescribe(true, contentsLevel-1, supportsLevel-1, curlevel);
      end
   end
end

function Object:shortDescribe(pronoun, contentsLevel, supportsLevel, curlevel)
   contentsLevel = contentsLevel or 1;
   supportsLevel = supportsLevel or 2;
   pronoun = pronoun or true;
   
   if(curlevel) then curlevel = curlevel.."  "; else curlevel = ""; end

   if(self.short) then 
      if(pronoun) then
	 io.write(curlevel, capitalize(self.pronoun), " ", self.short, "\n");
      else
	 io.write(curlevel, capitalize(self.short), "\n"); 
      end
   end

   if(contentsLevel > 0 
      and type(self.contains) == "table" and #self.contains > 0
      and (self == room.current or self.open or self.transparent)
   ) then
      if(self.short) then
	 io.write(curlevel, "In ", self.pronoun, " ", self.short, " is:\n");
      else
	 io.write(curlevel, "Inside is:\n");
      end
      for i,x in ipairs(self.contains) do
	 x:shortDescribe(true, contentsLevel-1, supportsLevel-1, curlevel);
      end
   end

   if(supportsLevel > 0 and type(self.supports) == "table" and #self.supports > 0) then
      if(self.short) then
	 io.write(curlevel, "On ", self.pronoun, " ", self.short, " is:\n");
      else
	 io.write(curlevel, "On it is:\n");
      end
      for i,x in ipairs(self.supports) do
	 x:shortDescribe(true, contentsLevel-1, supportsLevel-1, curlevel);
      end
   end
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
