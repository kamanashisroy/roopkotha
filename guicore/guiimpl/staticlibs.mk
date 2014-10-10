
GUIIMPL_CSOURCES=$(wildcard $(ROOPKOTHA_HOME)/libs/guiimpl/vsrc/*.c)
GUIIMPL_VSOURCE_BASE=$(basename $(notdir $(GUIIMPL_CSOURCES)))
OBJECTS+=$(addprefix $(ROOPKOTHA_HOME)$(OBJDIR_COMMON)/, $(addsuffix .o,$(GUIIMPL_VSOURCE_BASE)))

