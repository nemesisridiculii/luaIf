function mainloop()
   updateParser();
   
   if(current.room == nil) then error("The player is not in a room"); end
   current.room.visited = true;
   current.room:describe();

   while(current.running and current.living) do
      if(current.room == nil) then error("The player is not in a room"); end
      io.write(current.prompt());
      local input = io.read("*line");
      if(input == nil or input == "quit") then break; end
      io.write("\n");
      local res = parse(input);
      if(res ~= "Success") then
	 io.write(string.format("I'm sorry, I couldn't understand you. %s\n", res));
      end
   end

   print();
end
