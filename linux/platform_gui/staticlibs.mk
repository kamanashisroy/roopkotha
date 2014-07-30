
# Qt
#LIBS+=$(ROOPKOTHA_HOME)/linux/platform_gui/qtbuild/libqtguiproject.a
#LIBS+= -lQtGui -lQtCore -lpthread

# X11
#LIBS+=$(ROOPKOTHA_HOME)/linux/platform_gui/x11project/static_objects.a
#LIBS+=$(ROOPKOTHA_HOME)/build/.objects/x11_guicore.o
LIBS+= -lX11 -lpthread

include $(ROOPKOTHA_HOME)/$(PLATFORM)/platform_gui/x11project/staticlibs.mk
