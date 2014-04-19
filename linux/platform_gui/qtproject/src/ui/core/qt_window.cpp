
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

static qt_window_handle_event_t qt_handle_event;
int qt_process_mouse_event_helper(int flags, int key_code, int x, int y) {
	if(qt_handle_event.aroop_cb) {
		//GUI_INPUT_LOG("event callback ..\n");
    return qt_handle_event.aroop_cb(qt_handle_event.aroop_closure_data, flags, key_code, x, y);
	}
	return 0;
}

int qt_impl_window_set_event_handler(QTRoopkothaWindow*UNUSED_VAR(qw), qt_window_handle_event_t handler) {
	//GUI_INPUT_LOG("Setting event handler\n");
	qt_handle_event = handler;
	return 0;
}

QTRoopkothaWindow*qt_impl_window_create() {
	qt_handle_event.aroop_cb = NULL;
	return new QTRoopkothaWindow();
}

void qt_impl_window_destroy(QTRoopkothaWindow*qw) {
	//qw->~QTRoopkothaWindow();
	delete qw;
}

C_CAPSULE_END

