
VELATML_CSOURCES=$(wildcard $(ROOPKOTHA_HOME)/libs/velarichml/vsrc/*.c)
VELATML_VSOURCE_BASE=$(basename $(notdir $(VELATML_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(VELATML_VSOURCE_BASE)))

