luaIf.pdf: luaIf.tex
	while(pdflatex luaIf.tex; grep "Rerun" luaIf.log) do true; done

.PHONY: clean
clean :
	rm -f luaIf.aux luaIf.log luaIf.pdf *~
