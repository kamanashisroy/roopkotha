Roadmap
========

- [x] Study scintilla,jedit and eclipse for writing plugin.
	- scintilla has scinterm(an ncurses frontend for the library).
	- jedit loads a plugin.prop and actions.xml file. [see more](http://www.jedit.org/users-guide/plugin-implement-quicknotepadplugin.html), [services.xml](http://www.jedit.org/users-guide/plugin-implement-services.html),[dockables.xml](http://www.jedit.org/users-guide/plugin-implement-dockables.html),[BeanShell](http://www.jedit.org/users-guide/plugin-debugging.html) . 
	- eclipse has plugin.xml file. In this file it has **extension point**.
- [ ] Is it possible to use scintilla library based module here ?
- [ ] Make the gui implementations plug-in in flexible way.
- [ ] Load multiple gui implementations(x11,qt,wxwindow,ncurses or other) at a time.
- [ ] Write all gui commands in _guicommands_ space. Rehash and execute them from command handler.
- [ ] Write all the resource handlers in _guiresource_ space.
- [ ] Write all the file handlers in _filehandler_ space.
- [ ] Write all the document types in _doctype_ space.
- [ ] Write markdown rendering support.
- [ ] Study scintilla for scrolling.
- [ ] Study scintilla for editing.
- [ ] Compile and distribute for different platforms.
