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


addVerb({ "look", "at", capture.Object},
	function(obj)
	   if(current.room:alert("look", obj)) then return true; end
	   if(obj:before("look")) then return true; end
	   obj:describe();
	   obj:after("look");
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
   io.write("taken\n");
   obj:after("take");
end


addVerb({{"take", "pick up"}, capture.Thing},
	function(obj)
	   take(obj);
	   return true;
	end
	);
	