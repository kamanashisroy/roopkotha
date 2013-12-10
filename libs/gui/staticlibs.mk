GUI_CSOURCES=$(wildcard $(ROOPKOTHA_HOME)/libs/gui/vsrc/*.c)
GUI_VSOURCE_BASE=$(basename $(notdir $(GUI_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(GUI_VSOURCE_BASE)))

