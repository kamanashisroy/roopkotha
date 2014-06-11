
# Qt
#LIBS+=$(ROOPKOTHA_HOME)/linux/platform_gui/qtbuild/libqtguiproject.a
#LIBS+= -lQtGui -lQtCore -lpthread

# X11
LIBS+=$(ROOPKOTHA_HOME)/linux/platform_gui/x11project/x11_impl.o
LIBS+= -lX11 -lpthread

