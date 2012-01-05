PREFIX ?= /usr/local

all : test.exe

%.o : %.m
	gcc -g -DOG_W32 -I../headers -c -o $@ $^ `objfw-config --cppflags --objcflags`

test.exe : OGApplication.o OGWidget.o OGWindow.o OGBox.o OGVBox.o OGHBox.o OGButton.o OGComboBox.o OGComboBoxItem.o test.o
	gcc -mwindows -o test.exe *.o `objfw-config --libs`

clean :
	rm -f *.exe *.o
