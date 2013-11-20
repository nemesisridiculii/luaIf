addVerb({ {"place", "put"}, capture.Thing, {"on", "in"}, capture.Thing },
	function(one, two) 
	   print("placing", one, "->", two);
	   return true;
	end
);

addVerb({ "look" },
	function()
	   if(current.room:before("look")) then return true; end
	   current.room:describe();
	   current.room:after("look");
	   return true;
	end
);


function lookAt(obj)
	   if(current.room:alert("look", obj)) then return true; end
	   if(obj:before("look")) then return true; end
	   obj:describe();
	   obj:after("look");
end

addVerb({ "look", {"at", "in", "on"}, capture.Object},
	function(obj)
	   lookAt(obj);
	   return true;
	end
);

addVerb({ "look", capture.Object},
	function(obj)
	   lookAt(obj);
	   return true;
	end
);


addVerb({{"inventory", "inv"}},
	function()
	   if(current.room:alert("inventory")) then return true; end

	   if(#current.inventory.contains > 0) then
	      io.write("You are carrying:\n");
	      for i,v in ipairs(current.inventory.contains) do
		 v:shortDescribe(true, math.huge, math.huge, "");
	      end
	   else
	      io.write("You are not carrying anything\n");
	   end

	   return true;
	end
     );


function take(obj)
   if(current.room:alert("take", obj)) then return true; end
   if(obj:before("take")) then return true; end
   
   if(obj.fixed) then 
      io.write(capitalize(obj.pronoun), " ", obj.short, " is fixed in place\n"); 
      return true;
   end
   
   obj:liberate();
   current.inventory:placeIn(obj);
   if(obj:after("take")) then return true; end
   io.write("taken\n");   
end


addVerb({{"take", "pick up"}, capture.Thing},
	function(obj)
	   take(obj);
	   return true;
	end
	);
	

addVerb({"open", capture.Thing},
	function(obj)
	   if(not obj.openable) then
	      io.write("It cannot be opened\n");
	      return true;
	   end

	   if(obj.open) then
	      io.write("It is already open\n");
	      return true;
	   end
	   
	   if(current.room:alert("open", obj)) then return true; end
	   if(obj:before("open")) then return true end;
	   obj.open = true;
	   if(obj:after("open")) then return true; end
	   io.write("Opened\n");
	   return true;
	end
);
	   