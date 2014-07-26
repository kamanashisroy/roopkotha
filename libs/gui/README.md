GUI Core
=========

The core module responsible to build an interface for other modules to render gui application.

Events
=======

Events in this module are executed in a [chain of reponsiblitiy pattern](http://en.wikipedia.org/wiki/Chain-of-responsibility_pattern). Suppose a mouse event occured. Then it will ask menu, window and the related subclasses in sequence to let handle the event.

