
PROJECT_OBJDIR=$(ROOPKOTHA_HOME)/build/.objects/
#LIBS+=-lm
include $(ROOPKOTHA_HOME)/$(PLATFORM)/platform_gui/staticlibs.mk
include $(ROOPKOTHA_HOME)/libs/gui/staticlibs.mk
include $(ROOPKOTHA_HOME)/libs/rtree/staticlibs.mk
include $(ROOPKOTHA_HOME)/libs/guiimpl/staticlibs.mk
include $(ROOPKOTHA_HOME)/libs/doc/staticlibs.mk
include $(ROOPKOTHA_HOME)/libs/vela/staticlibs.mk
include $(ONUBODH_HOME)/transform/strtrans/staticlibs.mk
include $(ONUBODH_HOME)/libs/xmlparser/staticlibs.mk
include $(SHOTODOL_HOME)/libs/turbine/staticlibs.mk
