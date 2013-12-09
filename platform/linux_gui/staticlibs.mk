LINUX_GUI_CSOURCES=$(wildcard $(ROOPKOTHA_HOME)/platform/linux_gui/csrc/*.c)
LINUX_GUI_VSOURCE_BASE=$(basename $(notdir $(LINUX_GUI_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(LINUX_GUI_VSOURCE_BASE)))
#LIBS+=-lglib

