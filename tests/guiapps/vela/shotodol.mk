
all:
	module -load ../../../guiapps/pad/plugin.so
	module -load ../../../guiapps/velapad/plugin.so
	module -load ../../../guiapps/gcommands/plugin.so
	profiler
	velapad -i velapad.txt
	#velapad -i stickit.txt
	wa -n gui -fn vsrc/Font.c -l 100
	wa -n velagent -fn vsrc/CommandResourceLoader.c -l 100
	profiler
	shell -gl 1000000


