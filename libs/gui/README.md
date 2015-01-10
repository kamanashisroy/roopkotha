GUI Core
=========

The core module is responsible to build an interface for other modules to render gui application.

Graphics
==========

This is low level gui rendering code. It has ability to draw and fill rectangles, triangles and circles. It has the ability to draw strings as well. These commands are performed in different thread in platform implementation code. This is done by asynchronous [messaging passing](http://en.wikipedia.org/wiki/Message_passing).

Events
=======

Events in this module are executed in a [chain of reponsiblitiy pattern](http://en.wikipedia.org/wiki/Chain-of-responsibility_pattern). Suppose a mouse event occured. Then it will ask menu, window and the related subclasses in sequence to let handle the event. Note that the events are performed in the gui background thread, not in the event user thread, so this is an example of asynchronous [message passing](http://en.wikipedia.org/wiki/Message_passing).

GUICore
=======

GUICore is a [mediator](http://en.wikipedia.org/wiki/Mediator_pattern) of the underlying implementation of gui library. GUICore follows an [abstract factory pattern](http://en.wikipedia.org/wiki/Abstract_factory_pattern) to build GUIInput and Bag objects.


Menu
=====

Menu works like [presentation-abstraction-control](http://en.wikipedia.org/wiki/Presentation-abstraction-control) architecture. The [Menu](vsrc/Menu.vala) is the presentation part. The [Window](vsrc/Window.vala) is control part (especially see the _showFull()_ method). And a menu markup in [velagent](../velagent/README.md) is the abstraction part(specifically in the _plugMenu(extring\*menuML)_ method). The presentation part in [InteractiveMenu](vsrc/InteractiveMenu.vala) has some extra activities.

Architecture
==============

![architecture](../../docs/diagrams/roopkotha_gui.svg)
