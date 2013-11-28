DIR ?= .
luaIf_dir := $(DIR)

FILES := init.lua util.lua object.lua parser.lua verbs.lua current.lua main.lua
FILES := $(foreach x,$(FILES),$(luaIf_dir)/$x)

$(luaIf_dir)/luaIf.lua: $(FILES)
	cat $^ > $@

clean ::
	rm -f $(luaIf_dir)/luaIf.lua
