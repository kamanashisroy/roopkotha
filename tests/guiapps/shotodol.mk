
all:
	module -load ../../guiapps/pad/plugin.so
	module -load ../../guiapps/vela/plugin.so
	make -t velapad

writepad:
	writepad -t samples/writepad.txt
	noconsole

velapad:
	velapad -i samples/stickit.txt
	noconsole

