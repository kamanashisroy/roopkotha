
all:
	module -load ../../../guiapps/pad/plugin.so
	module -load ../../../guiapps/vela/plugin.so
	profiler
	velapad -i velapad.txt
	#velapad -i stickit.txt
	wa -n gui -fn vsrc/Font.c -l 100
	profiler


