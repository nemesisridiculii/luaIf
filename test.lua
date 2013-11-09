require "luaIf"

room = {};
thing = {};


room.livingroom = luaIf.Room:new{
   short = "The living room";
   desc = [[
The main living space of the house. This large 
room extends from the front door to the back.]];
   name = {"living", "room"};
   transparent=true;
};


thing.couch = luaIf.Thing:new{
   short = "a couch";
   desc = [[
A large brown leather couch.]];
   name = {"leather", "couch"};
};


room.livingroom:placeIn(thing.couch);





luaIf.current.room = room.livingroom;
luaIf.mainloop();
