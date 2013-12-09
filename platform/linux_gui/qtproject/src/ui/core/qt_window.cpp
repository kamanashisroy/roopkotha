
#include "core/config.h"
#include "core/decorator.h"
#include "core/txt.h"
#include <QtGui>
#include "qt_window.h"

C_CAPSULE_START

void qt_impl_window_paint_end(QTRoopkothaWindow*qw, QTRoopkothaGraphics*qtg) {
    // TODO see if the xultb_graphics is initiated ..
	//GUI_LOG("Painting list\n");
	qw->setPage(qtg->page);
	qtg->painter->end();
	//qw->update(0,0,win->width, win->height); // XXX why ??
	//qw->repaint(0,0,win->width, win->height); // TODO refresh only appropriate rectangle ..
	qw->repaint();
    //GUI_LOG("Rendering list(TODO: refresh now)\n");
}

void qt_impl_window_show(QTRoopkothaWindow*qw) {
    //qw->resize(win->width, win->height);// resize
    qw->show();
}

#if false
static int (*qt_handle_event)(int flags, int key_code, int x, int y) = NULL;
int qt_process_mouse_event_helper(int flags, int key_code, int x, int y) {
	if(qt_handle_event) {
//		GUI_INPUT_LOG("event callback ..\n");
        return qt_handle_event(flags, key_code, x, y);
	}
	return 0;
}

int xultb_gui_input_platform_init(int (*handle_event)(int flags, int key_code, int x, int y)) {
	//GUI_INPUT_LOG("Setting event handler\n");
	qt_handle_event = handle_event;
	return 0;
}
#endif

void qt_impl_window_create(QTRoopkothaWindow*qw) {
	new (qw) QTRoopkothaWindow();
}

void qt_impl_window_destroy(QTRoopkothaWindow*qw) {
	qw->~QTRoopkothaWindow();
}

C_CAPSULE_END

