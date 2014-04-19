
INCLUDES+=-Iinclude
INCLUDES+=-Iqtproject/inc

#CSOURCES=$(wildcard $(ROOPKOTHA_HOME)/platform/linux_gui/qtproject/src/ui/core/*.cpp)
#VSOURCE_BASE=$(basename $(notdir $(CSOURCES)))
#OBJECTS=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(VSOURCE_BASE)))

#ifeq ("$(CPP)", "")
#CPP=g++
#endif

#$(OBJDIR)/%.o:$(ROOPKOTHA_HOME)/platform/linux_gui/qtproject/src/ui/core/%.cpp
#	$(CPP) $(CFLAGS) -c $(INCLUDES) $< -o $@

