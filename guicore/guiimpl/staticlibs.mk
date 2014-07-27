
GUIIMPL_CSOURCES=$(wildcard $(ROOPKOTHA_HOME)/libs/guiimpl/vsrc/*.c)
GUIIMPL_VSOURCE_BASE=$(basename $(notdir $(GUIIMPL_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(GUIIMPL_VSOURCE_BASE)))

