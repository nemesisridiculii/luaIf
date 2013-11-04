luaIf.lua: subproj
	cp luaIf/luaIf.lua .

.PHONY: subproj
subproj:
	$(MAKE) -C luaIf
