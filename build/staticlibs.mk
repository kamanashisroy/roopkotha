
PROJECT_OBJDIR=$(ROOPKOTHA_HOME)$(OBJDIR_COMMON)/
#LIBS+=-lm
include $(ROOPKOTHA_HOME)/$(PLATFORM)/platform_gui/staticlibs.mk
include $(ROOPKOTHA_HOME)/libs/gui/staticlibs.mk
include $(ROOPKOTHA_HOME)/libs/listview/staticlibs.mk
include $(ROOPKOTHA_HOME)/libs/rtree/staticlibs.mk
include $(SHOTODOL_HOME)/libs/turbine/staticlibs.mk
include $(SHOTODOL_HOME)/libs/iterator/staticlibs.mk
include $(SHOTODOL_HOME)/$(PLATFORM)/platform_fileutils/staticlibs.mk
#include $(SHOTODOL_HOME)/$(PLATFORM)/lua/staticlibs.mk
