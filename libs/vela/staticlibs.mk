
ROOPVELA_CSOURCES=$(wildcard $(ROOPKOTHA_HOME)/libs/vela/vsrc/*.c)
ROOPVELA_VSOURCE_BASE=$(basename $(notdir $(ROOPVELA_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(ROOPVELA_VSOURCE_BASE)))

