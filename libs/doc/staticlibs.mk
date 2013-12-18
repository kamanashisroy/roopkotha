
ROOPDOC_CSOURCES=$(wildcard $(ROOPKOTHA_HOME)/libs/doc/vsrc/*.c)
ROOPDOC_VSOURCE_BASE=$(basename $(notdir $(ROOPDOC_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(ROOPDOC_VSOURCE_BASE)))

