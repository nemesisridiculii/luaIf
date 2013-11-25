addVerb({ {"place", "put"}, capture.Inventory, "on", capture.Thing },
	function(noun, dest) 
	   if(not dest.supports) then
	      io.write("That won't work.\n");
	      return true;
	   end

	   if(dest:alert("put_on", noun)) then return true; end
	   if(noun:before("put_on")) then return true; end
	   dest:placeOn(noun);
	   if(dest:after("put_on")) then return true; end
	   io.write("Placed ", noun.pronoun, " ", noun.short, 
		    " on ", dest.pronoun, " ", dest.short, ".\n");
	   return true
	end
);

addVerb({ {"place", "put"}, capture.Inventory, "in", capture.Thing },
	function(noun, dest) 
	   if(not dest.contains) then
	      io.write("That won't work.\n");
	      return true;
	   end

	   if(not dest.open) then
	      io.write("It isn't open\n");
	      return true;
	   end

	   if(dest:alert("put_in", noun)) then return true; end
	   if(noun:before("put_in")) then return true; end
	   dest:placeIn(noun);
	   if(dest:after("put_in")) then return true; end
	   io.write("Placed ", noun.pronoun, " ", noun.short, 
		    " in ", dest.pronoun, " ", dest.short, ".\n");
	   return true
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
	      io.write("It cannot be opened.\n");
	      return true;
	   end

	   if(obj.open) then
	      io.write("It is already open.\n");
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
	   
addVerb({"close", capture.Thing},
	function(obj)
	   if(not obj.openable) then
	      io.write("It cannot be closed.\n")
	      return true;
	   end

	   if(not obj.open) then
	      io.write("It is not open.\n");
	      return true;
	   end

	   if(current.room:alert("close", obj)) then return true; end
	   if(obj:before("close")) then return true; end
	   obj.open = false;
	   if(obj:after("close")) then return true; end
	   io.write("Closed.\n");
	   return true;
	end
);


function go(direction)
   direction = directions[direction];
   if(direction == nil) then
      io.write("That is not a direction I recognize.\n");
      return true;
   end

   if(current.room:alert("go", direction)) then return true; end
   
   local dest = current.room[direction];
   if(dest == nil) then
      io.write("You cannot go that way.\n");
      return ture;
   end

   if(dest:before("go", direction)) then return true; end
   current.room = dest;
   if(dest:after("go", direction)) then return true; end
   if(not dest.visited) then
      dest.visited = true;
      dest:describe();
   end
end

directions = {
   north = "north";
   n = "north";
   south = "south";
   s = "south";
   east = "east";
   e = "east";
   west = "west";
   w = "west";
   up = "up";
   down = "down";
}

addVerb({"go", capture.Rest},
	function(rest)
	   if(#rest ~= 1) then return false; end

	   go(rest[1]);
	   return true;
	end
     );



for d, dd in pairs(directions) do
   addVerb({d},
	   function()
	      go(dd);
	      return true;
	   end
	);
end

	      

   