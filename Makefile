PREFIX ?= /usr/local

all:
	@objfw-compile -Wall -g --lib 0.0 -o objgui \
		`pkg-config --cflags --libs gtk+-3.0` \
		`ls *.m | fgrep -v test.m`

test:
	@objfw-compile -Wall -g -o test \
		`pkg-config --cflags --libs gtk+-3.0` \
		*.m

install:
	mkdir -p ${PREFIX}/include/ObjGUI
	cp *.h ${PREFIX}/include/ObjGUI/
	cp libobjgui.so ${PREFIX}/lib/libobjgui.so.0.0
	ln -sf libobjgui.so.0.0 ${PREFIX}/lib/libobjgui.so.0
	ln -sf libobjgui.so.0 ${PREFIX}/lib/libobjgui.so

clean:
	rm -f test *.so *.o *~
