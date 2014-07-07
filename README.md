Roopkotha
=========

This is gui library and a text editor. This library is built upon shotodol development environment. It consists of modules that enable document rendering and basic gui rendering in different platforms.

Dependencies
============

You need to get the following project sources,

- [aroop](https://github.com/kamanashisroy/aroop)
- [shotodol](https://github.com/kamanashisroy/shotodol)
- [onubodh](https://github.com/kamanashisroy/onubodh)
- [roopkotha](https://github.com/kamanashisroy/roopkotha)


Getting the projects
====================

You need to get compressed(tar.gz/zip) distribution from the servers(for example, github.com/kamanashisroy/) .
Otherwise you can use git to clone the repositores, which is important if you want to change and develop the code
or if you want to see the history.

You need to create a project directory for all the associated projects. Then you need to decompress the projects in this
directory.

Suppose you are in 'a' directory. Then you need to decompress aroop,shotodol,onubodh,roopkotha in a directory.
If you are in linux, then putting 'ls' command in shell looks like this,

```
 a$ ls 
 aroop shotodol onubodh roopkotha . .. 
```


How to configure
===============

Now you need to build the projects sequentially. Please see the readme in aroop, shotodol and onubodh to build them.

To build roopkotha, you need to configure and generate the makefiles. To do that you need lua. And if you have 
filesystems module in lua then it would be easy. You need to execute the configure.lua script , like the following,

```
 a/roopkotha$ lua configure.lua
```

And you will get the output like the following,

This is the configure script built for shotodol
```
Project path /a/roopkotha > 
Aroop path /a/aroop > 
Shotodol path /a/shotodol > 
Onubodh path /a/onubodh > 
enable bluetooth ?(y/n) > n
enable debug (ggdb3) ?(y/n) > y
enable GUI debug ?(y/n) > n
```

How to build platform\_gui
======================

Now, after you have the _Makefile_ in the roopkotha directory you are ready to build.
```
 a/roopkotha$ ls
	Makefile
```
You need to build platform specific implementation first. You can either build _x11_ based implementation or you can build _Qt_ based implementation.

### Building with Qt.

Suppose we want to build it with Qt, then the following commands should build the _platform_ library,

```
 a/roopkotha$ cd linux/platform\_gui/build
 a/roopkotha/linux/platform\_gui/build$ make -f Makefile.build
 a/roopkotha/linux/platform\_gui/build$ make
 a/roopkotha/linux/platform\_gui/build$ make staticlib
 a/roopkotha/linux/platform\_gui/build$ cd ../../../
```
<a href="linux/platform_gui/qtproject/README.md">More on Qt based gui</a>

### Building with x11

In order to build x11 you need to go to x11 project directory and _make_.

```
 a/roopkotha$ cd linux/platform\_gui/x11project
 a/roopkotha/linux/platform\_gui/x11project$ make
 a/roopkotha/linux/platform\_gui/x11project$ ls
	x11_impl.o
 a/roopkotha/linux/platform\_gui/x11project$ cd ../../../
```
<a href="linux/platform_gui/x11project/README.md">More on x11 based gui</a>

Build roopkotha
==============

Now you can easily build roopkotha like,

```
 a/roopkotha$ make
 a/roopkotha$ ls
	shotodol.bin
```

The above command will create shotodol.bin as an executable binary. It reads the _shotodol.ske_ (_shake_ script file) for loading required
plugins. 

Running example
=============

Now go to tests/guiapps/vela and put make command and see if it works .

```
 a/roopkotha$ cd tests/guiapps/vela
 a/roopkotha/tests/guiapps/vela$ make
```

Understanding the architecture
==============================

TODO:show the diagram from my handwritten file.

You may want to know the architecture of shotodol to understand it better.

## Building doxygen documentation

You can also get the source code documentation in html/other document formats. You need _doxygen_ installed. And you can just _make_ the document and
see the output in docs/doxygen/ (or more in specifically docs/doxygen/html/).
```
 a/roopkotha$ make document 
 a/roopkotha$ ls docs/doxygen/html/ 
 a/roopkotha$ firefox docs/doxygen/html/
```

Historic versions
=================

 - QtBasedV0



Enjoy !


