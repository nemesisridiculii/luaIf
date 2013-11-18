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
};


thing.couch = luaIf.Thing:new{
   short = "couch";
   desc = [[
A large brown leather couch.]];
   name = {"large", "brown", "leather", "couch"};
   fixed=true;
};

room.livingroom:placeIn(thing.couch);

thing.chest = luaIf.Thing:new{
   short="chest";
   desc = [[
A beige plastic chest with a green lid servs as a cofee table.]];
   name = {"beige", "plastic", "chest"};
   fixed = true;
   transparent = true;
};
room.livingroom:placeIn(thing.chest);


thing.pipe = luaIf.Thing:new{
   short = "pipe";
   desc =[[
A plastic pipe.]];
   name = {"plastic", "pipe"}
}
thing.chest:placeIn(thing.pipe);

thing.junk = luaIf.Thing:new{
   short="junk";
   pronoun="some";
   desc = [[
Piles of stuff]];
   name = {"junk", "piles", "stuff"};
};
thing.chest:placeOn(thing.junk);

thing.thinggy = luaIf.Thing:new{
   pronoun="a";
   short="thinggy";
   desc="Some kind of thing, you're not sure what it is.";
   name={"unknown", "thinggy"};
};
luaIf.current.inventory:placeIn(thing.thinggy);
	


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
