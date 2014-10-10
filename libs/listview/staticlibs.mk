LISTVIEW_CSOURCES=$(wildcard $(ROOPKOTHA_HOME)/libs/listview/vsrc/*.c)
LISTVIEW_VSOURCE_BASE=$(basename $(notdir $(LISTVIEW_CSOURCES)))
OBJECTS+=$(addprefix $(ROOPKOTHA_HOME)$(OBJDIR_COMMON)/, $(addsuffix .o,$(LISTVIEW_VSOURCE_BASE)))

