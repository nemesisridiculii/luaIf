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

