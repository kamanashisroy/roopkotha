LISTVIEW_CSOURCES=$(wildcard $(ROOPKOTHA_HOME)/libs/listview/vsrc/*.c)
LISTVIEW_VSOURCE_BASE=$(basename $(notdir $(LISTVIEW_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(LISTVIEW_VSOURCE_BASE)))

