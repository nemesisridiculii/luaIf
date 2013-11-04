verbs = {};
junkWords = {'the'};

capture = {Thing = {__action="captureObject", type=Thing}};

function getVerbHandlers(verb)
   if(not verbs[verb]) then
      verbs[verb] = {};
   end

   return verbs[verb];
end

function addVerb(spec, func)
   if(type(spec[1]) == "table") then
      for i,v in ipairs(spec[1]) do
	 spec[1] = v;
	 addVerb(spec, func);
      end
    elseif(type(spec[1]) == "string") then
      local handlers = getVerbHandlers(spec[1]);
      handlers[#handlers + 1] = {spec = spec, func = func};
   end
end

function updateParser()
   parserSearchList = {};
   for k in pairs(verbs) do
      parserSearchList[#parserSearchList+1] = k;
   end

   table.sort(parserSearchList, 
	      function(a, b) 
		 return #a > #b;
	      end);
end


function parse(st)
   local foundVerb = false;
   
   for _,verb in ipairs(parserSearchList) do
      if(string.startsWith(st, verb)) then
	 foundVerb = true;
	 
	 for _,spec in ipairs(verbs[verb]) do
	    if(parseRest(spec, string.substring(st, #verb+1))) then
	       return "Success";
	    end
	 end
	 
      end
   end
   
   if(foundVerb) then
      return "CouldNotUnderstand";
   else
      return "VerbNotFound";
   end
end


function parseRerst(spec, st)
   local captures = {};

   while(#st > 0) do
      --remove junk words
      local junk = true;
      while(junk) do
	 junk = false;
	 for _,v in ipairs(junkWords) do
	    if(string.startsWith(st, v)) then
	       junk = true;
	       st = string.substring(st, #v + 1);
	    end
	 end
      end

      --capture the next piece
   end
   
   return spec.func(unpack(captures));
   
end