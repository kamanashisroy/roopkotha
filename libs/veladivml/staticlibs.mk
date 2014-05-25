
VELADIV_CSOURCES=$(wildcard $(ROOPKOTHA_HOME)/libs/veladivml/vsrc/*.c)
VELADIV_VSOURCE_BASE=$(basename $(notdir $(VELADIV_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(VELADIV_VSOURCE_BASE)))

