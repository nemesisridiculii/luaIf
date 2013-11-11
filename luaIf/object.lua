
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

function Object:describe()
   if(self.short) then io.write(capitalize(self.short), "\n"); end
   if(self.desc) then io.write(self.desc, "\n"); end
   if(type(self.contains) == "table") then
      if(self.short) then
	 io.write("\nIn ", self.pronoun, " ", self.short, " is:\n");
      else
	 io.write("Inside is:\n");
      end
      for i,x in ipairs(self.contains) do
	 if(x.short) then io.write("  ", capitalize(x.pronoun), " ", x.short, "\n"); end
      end
   end

   if(type(self.supports) == "table") then
      if(self.short) then
	 io.write("\nOn ", self.pronoun, " ", self.short, " is:\n");
      else
	 io.write("On it is:\n");
      end
      for i,x in ipairs(self.supports) do
	 if(x.short) then io.write("  ", capitalize(x.pronoun), " ", x.short, "\n"); end
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
