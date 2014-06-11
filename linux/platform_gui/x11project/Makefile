include ../../../build/.config.mk
CURRENTPATH=$(ROOPKOTHA_HOME)/linux/platform_gui/x11project

INCLUDEPATH+=$(VALA_HOME)/aroop/core/inc
INCLUDEPATH+=$(ROOPKOTHA_HOME)/libs/gui/include
INCLUDEPATH+=$(ONUBODH_HOME)/libs/rawimg/include
INCLUDEPATH+=$(SHOTODOL_HOME)/libs/iostream/include
INCLUDEPATH+=$(SHOTODOL_HOME)/libs/propeller/include
INCLUDEPATH+=$(SHOTODOL_HOME)/libs/watchdog/include
INCLUDEPATH+=inc
INCLUDES=$(addprefix -I,$(INCLUDEPATH))

TARGET=x11_impl.o

all:$(TARGET)

x11_impl.o:src/x11_guicore.c
	gcc -c $(INCLUDES) src/x11_guicore.c -o $@ -lX11

