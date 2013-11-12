current = {
   inventory = Object:new{
      pronoun="your";
      short="inventory";
      name={"inventory"};
      contains={};
      container=true};
   living = true;
   running = true;
   prompt = function() 
	       io.write("\n");
	       if(current.room and current.room.short) then io.write(capitalize(current.room.short), "\n"); end
	       if(current.score) then 
		  io.write("[", current.score, " ");
		  if(current.maxScore) then io.write("/ ", current.maxScore, " "); end
		  io.write("pts.] ");
	       end
	       io.write("}>");
	    end
};


function RecursiveItterator(x, visible, first)
   local vis = false;
   if(visible == nil or first == nil) then 
      vis = true; 
   else
      vis = x.open or x.transparent or false;
      if(visible == false) then vis = not vis; end
   end
   
   if(vis and (x.contains ~= nil)) then
      for i,v in ipairs(x.contains) do
	 coroutine.yield(v);
	 RecursiveItterator(v, visible, true);
      end
   end
   
   if(x.supports ~= nil) then
      for i,v in ipairs(x.supports) do
	    coroutine.yield(v);
	    RecursiveItterator(v, visible, true);
      end
   end
end


function visible(object)
   local co;
   if(object == nil) then
      co = coroutine.create(function() 
			       RecursiveItterator(current.room, true);
			       RecursiveItterator(current.inventory, true);
      end);
   else
      co = coroutine.create(function() RecursiveItterator(object, true) end);
   end
   
   return function()
      local res, val = coroutine.resume(co);

      if(res == true) then 
	 return val; 
      else 
	 return nil; 
      end
   end
end

function lookFor(tokens, object)
   for x in visible(object) do
      if(x:match(tokens)) then return x; end
   end
   return nil;
end
