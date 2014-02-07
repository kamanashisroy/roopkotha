
-include .config.mk
-include $(SHOTODOL_HOME)/plugin.mk

all:makecore makeapp makeshotodol

makeapp:
	$(BUILD) -C guiapps/pad
	$(BUILD) -C guiapps/vela

cleanapp:
	$(CLEAN) -C guiapps/pad
	$(CLEAN) -C guiapps/vela

makecore:
	$(BUILD) -C libs/gui
	$(BUILD) -C platform/linux_gui
	$(BUILD) -C libs/rtree
	$(BUILD) -C libs/guiimpl
	$(BUILD) -C libs/doc
	$(BUILD) -C libs/vela

cleancore:
	$(CLEAN) -C libs/gui
	$(CLEAN) -C platform/linux_gui
	$(CLEAN) -C libs/rtree
	$(CLEAN) -C libs/guiimpl
	$(CLEAN) -C libs/doc
	$(CLEAN) -C libs/vela

clean:cleancore cleanapp

include tests/test.mk
