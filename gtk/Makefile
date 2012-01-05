PREFIX ?= /usr/local

all:
	@objfw-compile -DOG_GTK -Wall -g --lib 0.0 -o objgui -I../headers \
		`pkg-config --cflags --libs gtk+-3.0` \
		`ls *.m | fgrep -v test.m`

test:
	@objfw-compile -DOG_GTK -Wall -g -o test -I../headers \
		`pkg-config --cflags --libs gtk+-3.0` \
		*.m

install:
	mkdir -p ${PREFIX}/include/ObjGUI
	cp ../headers/*.h ${PREFIX}/include/ObjGUI/
	cp libobjgui.so ${PREFIX}/lib/libobjgui.so.0.0
	ln -sf libobjgui.so.0.0 ${PREFIX}/lib/libobjgui.so.0
	ln -sf libobjgui.so.0 ${PREFIX}/lib/libobjgui.so

clean:
	rm -f test *.so *.o *~
