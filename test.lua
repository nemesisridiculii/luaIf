require "luaIf"

room = {};
thing = {};


room.livingroom = luaIf.Room:new{
   short = "living room";
   desc = [[
The main living space of the house. This large 
room extends from the front door to the back.
   There is a large brown leather couch here.]];
   name = {"living", "room"};
   transparent=true;
};


thing.couch = luaIf.Thing:new{
   short = "couch";
   desc = [[
A large brown leather couch.]];
   name = {"large", "brown", "leather", "couch"};
};


room.livingroom:placeIn(thing.couch);


luaIf.addVerb({"kill self"},
	      function()
		 print("You find the nearest heavy object and bludgen yourself to death");
		 luaIf.current.living = false;
		 return true;
	      end
	   );

luaIf.current.score = 0;


luaIf.current.room = room.livingroom;
luaIf.mainloop();
