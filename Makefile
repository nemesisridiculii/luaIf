DIR ?= .
luaIf_dir := $(DIR)

FILES := init.lua util.lua object.lua parser.lua verbs.lua current.lua main.lua
FILES := $(foreach x,$(FILES),$(luaIf_dir)/$x)

$(luaIf_dir)/luaIf.lua: $(FILES)
	cat $^ > $@
	echo "version = '"`git --git-dir $(luaIf_dir)/.git describe --tags`"';" >> $@
	echo "fullVersion = '"`git --git-dir $(luaIf_dir)/.git describe --long --tags`"';" >> $@

clean ::
	rm -f $(luaIf_dir)/luaIf.lua
