GUI_CSOURCES=$(wildcard $(ROOPKOTHA_HOME)/libs/gui/vsrc/*.c)
GUI_VSOURCE_BASE=$(basename $(notdir $(GUI_CSOURCES)))
OBJECTS+=$(addprefix $(ROOPKOTHA_HOME)$(OBJDIR_COMMON)/, $(addsuffix .o,$(GUI_VSOURCE_BASE)))

