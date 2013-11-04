addVerb({ {"place", "put"}, capture.Thing, {"on", "in"}, capture.Thing },
   function(one, two) 
      print("placing", one, "->", two);
   end);
