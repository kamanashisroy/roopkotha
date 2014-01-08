RTREE_C_IMPL_CSOURCES=$(wildcard $(ROOPKOTHA_HOME)/libs/rtree/vsrc/*.c)
RTREE_C_IMPL_VSOURCE_BASE=$(basename $(notdir $(RTREE_C_IMPL_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(RTREE_C_IMPL_VSOURCE_BASE)))

