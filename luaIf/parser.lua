verbs = {};
junkWords = {"the", "a"};

capture = {
   Object = {__action="capture", type=Object};
   Thing = {__action="capture", type=Thing};
   Inventory = {__action="capture", type="INVENTORY"};
   Rest = {__action="capture", type="REST"};
};

function getVerbHandlers(verb)
   if(verbs[verb] == nil) then
      verbs[verb] = {};
   end

   return verbs[verb];
end

function addVerb(spec, func)
   local verblist;
   if(type(spec[1]) == "table") then
     verblist = spec[1];
   else
     verblist = {spec[1]};
   end

   for i,v in ipairs(verblist) do
     local handlers = getVerbHandlers(v);
     handlers[#handlers + 1] = {spec = spec, func = func};
   end
end

function updateParser()
   parserSearchList = {};
   for k in pairs(verbs) do
      parserSearchList[#parserSearchList+1] = {verb = k, tokens = tokenize(k)};
   end

   table.sort(parserSearchList, 
	      function(a, b) 
		 return #a.tokens > #b.tokens;
	      end);
end


function parse(st)
   local foundVerb = false;
   st = string.lower(st);
   local tokens = tokenize(st);

   for _,verb in ipairs(parserSearchList) do
      if(matchVerb(tokens, verb)) then
	 foundVerb = true;
	 for _,spec in ripairs(verbs[verb.verb]) do
	    if(parseRest(spec, tokens, #verb.tokens)) then
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

function matchVerb(tokens, verb)
  if(#tokens < #verb.tokens) then return false; end

  for i=1,#verb.tokens do
    if(tokens[i] ~= verb.tokens[i]) then return false; end
  end

  return true;
end

function parseRest(spec, tokens, tknidx)
   local thiscaptokens;
   local captures = {};
   local captureTypes = {};
   local func = spec.func;
   spec = spec.spec;

   --use token literals to break up the tokens for the captures.
   local capinqueue = false;
   for i=2,#spec do
     local tknspec;
     if(type(spec[i]) == "string") then
       tknspec = {spec[i]};
     else
       tknspec = spec[i];
     end

     if(tknspec.__action == "capture") then
       if(capinqueue) then error("Cannot have two consecutive captures.") end;
       
       thiscaptokens = {};
       captureTypes[#captureTypes+1] = tknspec;
       captures[#captures+1] = thiscaptokens;
       capinqueue = true;
     else
        local nfound = true;
	while(tknidx < #tokens and nfound) do
	  tknidx = tknidx + 1;

	  for i=1,#tknspec do
	    if(tokens[tknidx] == tknspec[i]) then 
	      nfound = false;
	      break;
	    end
	  end
	  if(nfound) then
	    if(not capinqueue) then return false;
	    else thiscaptokens[#thiscaptokens + 1] = tokens[tknidx]; end
	  end
	end

	if(nfound) then return false; end --ran out of tokens
	capinqueue = false;
      end

    end

    if(capinqueue) then
       if(tknidx >= #tokens) then return false; end
       while(tknidx < #tokens) do
	  tknidx = tknidx+1;
	  thiscaptokens[#thiscaptokens+1] = tokens[tknidx];
       end
    else
       if(tknidx < #tokens) then
	  return false;
       end
    end

    --now try to capture the results
    local captureObjects = {};
    for i,v in ipairs(captures) do
       if(captureTypes[i].type == "REST") then
	  captureObjects = v;
       elseif(captureTypes[i].type == "INVENTORY") then
	  for x in visible(current.inventory) do
	     if(x:match(v)) then
		captureObjects[i] = x;
		break;
	     end
	  end
       else
	  for x in visible() do
	     if(x:isA(captureTypes[i].type) and x:match(v)) then
		captureObjects[i] = x;
		break;
	     end
	  end
       end

       if(captureObjects[i] == nil) then return false; end	  
    end
       
   return func(unpack(captureObjects));
   
end


function tokenize(st)
  local tokens = {};
  local tokenstart = 1;
  local type = 0;
  for i=1,#st do
    local chartype = getCharType(st, i);
    if(chartype ~= type) then
      if(type ~= 0) then
        tokens[#tokens+1] = string.sub(st, tokenstart, i-1);
      end

      tokenstart = i;
      type = chartype;
    end
  end

  tokens[#tokens+1] = string.sub(st, tokenstart);

  return tokens;
end

function  getCharType(st, i)
  local char = string.sub(st, i, i);
  if(char:match('[%a-]')) then return 1; end
  if(char:match('%p')) then return 2; end

  return 0;
end

  
    
    
		  
