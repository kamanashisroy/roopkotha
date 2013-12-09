
-include .config.mk
-include $(SHOTODOL_HOME)/plugin.mk

all:makecore makeankhi makeshotodol

makeankhi:
	$(BUILD) -C editor/pad

cleanankhi:
	$(CLEAN) -C editor/pad

makecore:
	$(BUILD) -C libs/gui
	$(BUILD) -C platform/linux_gui
	$(BUILD) -C libs/guiimpl

cleancore:
	$(CLEAN) -C libs/gui
	$(CLEAN) -C platform/linux_gui
	$(CLEAN) -C libs/guiimpl

clean:cleancore cleanankhi

include tests/test.mk
