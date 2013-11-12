addVerb({ {"place", "put"}, capture.Thing, {"on", "in"}, capture.Thing },
	function(one, two) 
	   print("placing", one, "->", two);
	   return true;
	end
);

addVerb({ "look" },
	function()
	   if(current.room == nil) then error("The error is not in a room"); end
	   current.room:describe();
	   return true;
	end
);


addVerb({ "look", "at", capture.Object},
	function(obj)
	   obj:describe();
	   return true;
	end
);


addVerb({{"inventory", "inv"}},
	function()
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