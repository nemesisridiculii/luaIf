
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

    if(self.pronoun == t) then found = true; end

    if(not found) then
       for i,n in ipairs(self.name) do
	  if(n == t) then found=true; break; end
       end
    end

    if(not found) then
       for i,n in ipairs(junkWords) do
	  if(n == t) then found=true; break; end
       end
    end

    if(found == false) then return false; end
  end

  return true;
end

function Object:placeIn(obj)
   obj:liberate();
   if(self.contains == nil) then self.contains = {}; end

   self.contains[#self.contains+1] = obj;
   obj.container = self;
end

function Object:placeOn(obj)
   obj:liberate();
   if(self.supports == nil) then self.supports = {}; end

   self.supports[#self.supports+1] = obj;
   obj.supporter = self;
end

function Object:removeFrom(obj)
   if(obj.supporter == self) then
      if(self.supports == nil) then error("Tried to remove an object that isn't supported"); end
      obj.supporter = nil;
      local found = false;
      for i,v in ipairs(self.supports) do
	 if(v == obj) then 
	    table.remove(self.supports, i);
	    found = true;
	    break;
	 end
      end
      if(not found) then error("Object wasn't in the list"); end
   else if(obj.container == self) then
	 if(self.contains == nil) then error("Tried to remove an object that is not contianed"); end
	 obj.container = nil;
	 local found = false
	 for i,v in ipairs(self.contains) do
	    if(v == obj) then
	       table.remove(self.contains, i);
	       found = true;
	       break;
	    end
	 end
	 if(not found) then error("Object wasn't in the list"); end
	end
   end
end

function Object:liberate()
   if(self.container) then
      self.container:removeFrom(self);
   end

   if(self.supporter) then
      self.supporter:removeFrom(self);
   end
end
   
function Object:details()
   local res = {};
   if(self.desc) then tableappend(res, self.desc); end
   return table.concat(res);
end

function Object:phrase(pronoun, cap)
   local res = {};
   if(cap) then cap = capitalize else cap = function(x) return x; end end

   if(self.short) then 
      if(pronoun) then
	 tableappend(res, cap(self.pronoun), " ", self.short);
      else
	 tableappend(res, cap(self.short)); 
      end
   end

   return table.concat(res);
end

function Object:describe(contentsLevel, supportsLevel, curlevel)
   contentsLevel = contentsLevel or 1;
   supportsLevel = supportsLevel or 2;
   if(curlevel) then curlevel = curlevel.."  "; else curlevel = ""; end
   
   io.write(curlevel, self:phrase(true, true), "\n\n")
   io.write(curlevel, self:details(), "\n");
   
   self:describeChildren(contentsLevel, supportsLevel, curlevel);
end

function Object:describeChildren(contentsLevel, supportsLevel, curlevel)
   if(contentsLevel > 0 
	 and (self == current.room or self.open or self.transparent)
   ) then
      if(type(self.contains) == "table" and #self.contains > 0) then
	 if(self.short) then
	    io.write("\n", curlevel, "In ", self.pronoun, " ", self.short, " is:\n");
	 else
	    io.write("\n", curlevel, "Inside is:\n");
	 end
	 for i,x in ipairs(self.contains) do
	    x:shortDescribe(true, contentsLevel-1, supportsLevel-1, curlevel);
	 end
      else
	 if(self.short) then
	    io.write("\n", curlevel, self.pronoun, " ", self.short, " is empty\n");
	 else
	    io.write("\n", curlevel, "It is empty\n");
	 end
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
   if(curlevel) then curlevel = curlevel.."  "; else curlevel = ""; end
   pronoun = pronoun or true;
   
   io.write(curlevel, self:phrase(pronoun, true), "\n");
   
   self:describeChildren(contentsLevel, supportsLevel, curlevel);
end



function Object:before(what, ...)
   return self:hook("before", what, ...);
end

function Object:after(what, ...)
   return self:hook("after", what, ...);
end

function Object:alert(what, ...)
   return self:hook("alert", what, ...);
end

function Object:hook(when, what, ...)
   if(type(what) ~= "string" or what == "") then 
      error("hook expects the name of the event."); 
   end

   what = when.."_"..what;
   if(type(self[what]) == "function") then
      return self[what](self, ...);
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
