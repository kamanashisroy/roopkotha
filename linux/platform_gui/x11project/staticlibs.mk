

ROOKOTHA_X11_PROJECT_CSOURCES=$(wildcard $(ROOPKOTHA_HOME)/linux/platform_gui/x11project/csrc/x11_guicore.c)
ROOKOTHA_X11_PROJECT_VSOURCE_BASE=$(basename $(notdir $(ROOKOTHA_X11_PROJECT_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(ROOKOTHA_X11_PROJECT_VSOURCE_BASE)))

