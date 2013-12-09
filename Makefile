
-include .config.mk
-include $(SHOTODOL_HOME)/plugin.mk

all:makecore makeankhi makeshotodol

makeankhi:
	$(BUILD) -C editor/pad

cleanankhi:
	$(CLEAN) -C editor/pad

makecore:
	$(BUILD) -C platform/linux_gui
	$(BUILD) -C libs/gui

cleancore:
	$(CLEAN) -C platform/linux_gui
	$(CLEAN) -C libs/gui

clean:cleancore cleanankhi

include tests/test.mk
