
PROJECT_OBJDIR=$(ROOPKOTHA_HOME)/build/.objects/
#LIBS+=-lm
include $(ROOPKOTHA_HOME)/platform/linux_gui/staticlibs.mk
include $(ROOPKOTHA_HOME)/libs/gui/staticlibs.mk
include $(ROOPKOTHA_HOME)/libs/rtree/staticlibs.mk
include $(ROOPKOTHA_HOME)/libs/guiimpl/staticlibs.mk
include $(ROOPKOTHA_HOME)/libs/doc/staticlibs.mk
include $(SHOTODOL_HOME)/libs/turbine/staticlibs.mk
