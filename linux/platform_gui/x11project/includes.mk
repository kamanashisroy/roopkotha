INCLUDES+=-Iinclude
CSOURCES=$(wildcard csrc/x11_guicore.c)
VSOURCE_BASE=$(basename $(notdir $(CSOURCES)))
OBJECTS=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(VSOURCE_BASE)))

