
#include "core/config.h"
#include "core/decorator.h"
C_CAPSULE_START
#include "shotodol_watchdog.h"
#define watchdog_log_string(x) aroop_cl_shotodol_shotodol_watchdog_logString(__FILE__, __LINE__, 10 , x)
#include "aroop_core.h"
#include "core/txt.h"
#include "opp/opp_indexed_list.h"
#include "shotodol_gui.h"
C_CAPSULE_END
#include <QtGui>
#include "qt_message.h"
#include "qt_guicore.h"
#include "qt_window.h"


C_CAPSULE_START
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

static opp_factory pwins;
static opp_factory pgfx;
int perform_window_task(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len) {
	// check the task ..
	static int ready = 0;
	ready++;
	int cmd = msg_numeric_value(msg, offset, cur_type, cur_len);
	printf("msglen:%d, offset %d, key length %d\n", msg->len, *offset, *cur_len);
	SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
	SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
	int wid = msg_numeric_value(msg, offset, cur_type, cur_len);
	QTRoopkothaWindow*qwin = (QTRoopkothaWindow*)opp_indexed_list_get(&pwins, wid);
	QTRoopkothaGraphics*qgfx = (QTRoopkothaGraphics*)opp_indexed_list_get(&pgfx, wid);
	switch(cmd) {
	case ENUM_ROOPKOTHA_GUI_WINDOW_TASK_SHOW_WINDOW:
		if(qwin == NULL) {
			qt_handle_event.aroop_cb = NULL;
			if(qgfx == NULL) {
				qgfx = new QTRoopkothaGraphics();
				aroop_indexed_list_set(&pgfx, wid, qgfx);
			}
			qwin = new QTRoopkothaWindow();
			aroop_indexed_list_set(&pwins, wid, qwin);
			watchdog_log_string("Created new window\n");
		} else {
			watchdog_log_string("Show window\n");
			qwin->show();
		}
	break;
	case ENUM_ROOPKOTHA_GUI_WINDOW_TASK_DESTROY:
		aroop_indexed_list_set(&pwins, wid, NULL);
		if(qwin != NULL) {
			delete qwin;
		}
		aroop_indexed_list_set(&pgfx, wid, NULL);
		if(qgfx != NULL) {
			delete qgfx;
		}
	break;
#if 0
	case ENUM_ROOPKOTHA_GUI_WINDOW_TASK_PAINT_COMPLETE:
		qw->setPage(qtg->page);
		qtg->painter->end();
		qw->repaint();
	break;
#endif
	}
	return 0;
}

int qt_window_init() {
	memset(&pwins, 0, sizeof(pwins));
	memset(&pgfx, 0, sizeof(pgfx));
	OPP_INDEXED_LIST_CREATE2(&pwins, 2, OPPL_POINTER_NOREF);
	OPP_INDEXED_LIST_CREATE2(&pgfx, 2, OPPL_POINTER_NOREF);
	return 0;
}

int qt_window_deinit() {
	// TODO destroy all the windows
	opp_factory_destroy(&pwins);
	opp_factory_destroy(&pgfx);
	return 0;
}

C_CAPSULE_END

