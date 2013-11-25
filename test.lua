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
   openable = true;
   before_open = function(self)
      if(self.supports == nil or #self.supports > 0) then
	 io.write([[
You don't want to open the chest and knock all the stuff on the 
floor do you?
]]);
      else
	 io.write("You unlatch the top and open the chest.\n");
	 self.open = true;
	 luaIf.current.score = luaIf.current.score + 5;
      end
      return true;
   end;

   before_close = function(self)
      io.write("You close the lid and latch the latches.\n");
      self.open = false;
      luaIf.current.score = luaIf.current.score - 5;
      return true;
   end;

   alert_put_on = function(self, x)
      if(self.open) then
	 io.write("It falls in.\n");
	 self:placeIn(x);
	 return true;
      else
	 io.write("You place ", x.pronoun, " ", x.short, 
		  " on top of the chest.\n");
	 self:placeOn(x);
	 return true;
      end
   end;
};
room.livingroom:placeIn(thing.chest);


thing.pipe = luaIf.Thing:new{
   short = "pipe";
   desc =[[
A plastic pipe.]];
   name = {"plastic", "pipe"};
   after_take = function() 
      luaIf.current.score = luaIf.current.score + 1; 
   end;
}
thing.chest:placeIn(thing.pipe);

thing.junk = luaIf.Thing:new{
   short="junk";
   pronoun="some";
   desc = [[
Piles of stuff]];
   name = {"junk", "piles", "stuff"};
   after_take = function() 
      luaIf.current.score = luaIf.current.score + 1; 
   end;
};
thing.chest:placeOn(thing.junk);

thing.thinggy = luaIf.Thing:new{
   pronoun="a";
   short="thinggy";
   desc="Some kind of thing, you're not sure what it is.";
   name={"unknown", "thinggy"};
};
luaIf.current.inventory:placeIn(thing.thinggy);
	

waysToDie = {};
waysToDie[thing.pipe] = [[
You grab the pipe and repeated beat yourself in the head until
you fall unconcious and die.
]];

luaIf.addVerb({"kill self"},
	      function()
		 
		 for x in luaIf.visible() do
		    for k,v in pairs(waysToDie) do
		       if(k == x) then
			  io.write(v);
			  luaIf.current.living = false;
			  luaIf.current.score = luaIf.current.score + 1;
			  return true;
		       end
		    end
		 end

		 print("You beat your head against the wall until you die.");
		 luaIf.current.living = false;
		 return true;
	      end
	   );

luaIf.current.score = 0;
luaIf.current.maxScore = 7;

luaIf.current.room = room.livingroom;
luaIf.mainloop();

io.write("You scored ", luaIf.current.score, 
	 " out of a possible ", luaIf.current.maxScore, " points\n");
