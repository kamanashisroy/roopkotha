roopkotha
=========
This is gui library and a text editor.

Dependencies
============

You need to get the following prject sources,

- aroop
- shotodol
- onubodh
- roopkotha


Getting the projects
====================

You need to get compressed(tar.gz/zip) distribution from the servers(for example, github.com/kamanashisroy/) .
Otherwise you can use git to clone the repositores, which is important if you want to change and develop the code
or if you want to see the history.

You need to create a project directory for all the associated projects. Then you need to decompress the projects in this
directory.

Suppose you are in 'a' directory. Then you need to uncompress aroop,shotodol,onubodh,roopkotha in a directory.
If you are in linux, then putting 'ls' command in shell looks like this,

a$ ls 
aroop shotodol onubodh roopkotha . .. 


How to confgure
===============

Now you need to build the projects sequentially. Please see the readme in aroop, shotodol and onubodh to build them.

To build roopkotha, you need to configure and generate the makefiles. To do that you need lua. And if you have 
filesystems module in lua then it would be easy. You need to execute the configure.lua script , like the following,

a/roopkotha$ lua configure.lua

And you shall get the output like the following,

This is the configure script built for shotodol
Project path /a/roopkotha > 
Aroop path /a/aroop > 
Shotodol path /a/shotodol > 
Onubodh path /a/onubodh > 
enable bluetooth ?(y/n) > n
enable debug (ggdb3) ?(y/n) > y
enable GUI debug ?(y/n) > n

How to build platform_gui
======================

Now, after you have the Makefile in the roopkotha directory you are ready to build. You need to build platform
first. Suppose we want to build it with qt, then the following code may build the platform library,

a/roopkotha$cd linux/platform_gui/build;make -f Makefile.build;make;make staticlib;cd ../../../


Build roopkotha
==============

Now you can easily build roopkotha like,

a/roopkotha$ make

The above command will create shotodol.bin as an executable binary. It reads the shotodol.mk for loading required
plugins. 

Running example
=============

Now go to tests/guiapps/vela and put make command and see if it works .

a/roopkotha/tests/guiapps/vela$ make

Enjoy !








