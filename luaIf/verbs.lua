addVerb({ {"place", "put"}, capture.Thing, {"on", "in"}, capture.Thing },
	function(one, two) 
	   print("placing", one, "->", two);
	   return true;
	end
);

addVerb({ "look" },
	function()
	   print(current.room.short);
	   if(not current.room.visited) then
	      print(current.room.desc);
	      current.room.visited = true;
	   end
	   return true;
	end
);


addVerb({ "look", "at", capture.Object},
	function(obj)
	   print(obj.short);
	   print(obj.desc);
	   return true;
	end
);

