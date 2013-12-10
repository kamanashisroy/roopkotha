
-include .config.mk
-include $(SHOTODOL_HOME)/plugin.mk

all:makecore makeapp makeshotodol

makeapp:
	$(BUILD) -C guiapps/pad

cleanapp:
	$(CLEAN) -C guiapps/pad

makecore:
	$(BUILD) -C libs/gui
	$(BUILD) -C platform/linux_gui
	$(BUILD) -C libs/guiimpl

cleancore:
	$(CLEAN) -C libs/gui
	$(CLEAN) -C platform/linux_gui
	$(CLEAN) -C libs/guiimpl

clean:cleancore cleanapp

include tests/test.mk
