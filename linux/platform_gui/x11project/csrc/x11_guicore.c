/*
 * This file part of MiniIM.
 *
 * Copyright (C) 2007  Kamanashis Roy
 *
 * MiniIM is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * MiniIM is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with MiniIM.  If not, see <http://www.gnu.org/licenses/>.
 *
 */
/*
 * x11_guicore.cpp
 *
 *  Created on: Jun 11, 2014
 *      Author: ayaskanti
 */
#include "aroop/core/config.h"
#include "aroop/core/decorator.h"

#include <X11/Xlib.h> 
#include <X11/Xutil.h>
#include "aroop/aroop_core.h"
#include "aroop/opp/opp_factory.h"
#include "aroop/core/xtring.h"
#include "aroop/opp/opp_queue.h"
#include "shotodol_gui.h"
#include "shotodol_watchdog.h"
#define watchdog_log_string(x) shotodol_watchdog_logString(__FILE__, __LINE__, 10 , x)
#include "x11_guicore.h"


#undef UNUSED_VAR
#define UNUSED_VAR(x) x

C_CAPSULE_START
struct x11_guicore {
	Display*disp;
  	int scrn;
	//XColor rgbc;
	opp_factory_t pwins;
	opp_factory_t layers;
	opp_factory_t pgfx;
	opp_queue_t incoming;
	opp_queue_t outgoing;
	int width;
	int height;
	int wid;
};
static char*argv[2] = {"shotodol.bin", "man"};
static int argc = 1;
static struct x11_guicore gcore;

PlatformRoopkothaGUICore*platform_impl_guicore_create() {
	memset(&gcore, 0, sizeof(gcore));
	watchdog_log_string("**************************Allocating new application**************\n");
	opp_queue_init2(&gcore.incoming, 0);
	opp_queue_init2(&gcore.outgoing, 0);
	watchdog_log_string("Initiated queue\n");
	platform_window_init();
	gcore.disp = XOpenDisplay("");
	gcore.scrn = DefaultScreen(gcore.disp);
	return &gcore;
}

int platform_impl_guicore_destroy(PlatformRoopkothaGUICore*UNUSED_VAR(nothing)) {
	platform_window_deinit();
	opp_queue_deinit(&gcore.incoming);
	opp_queue_deinit(&gcore.outgoing);
	//XFreeGC(gcore.disp, gc);
	XCloseDisplay(gcore.disp);
	return 0;
}

#include "msg_parser.c"
#include "x11_graphics.c"
#include "x11_window.c"
#include "x11_misc.c"
static int repaint_x11() {
	int i = 0;
	for(i = 0; i < 24; i++) {
		aroop_txt_t*msg = opp_indexed_list_get(&gcore.layers, i);
		if(!msg)continue;
		x11_window_t*win = NULL;
		int offset = 0;
		int cur_key = 0;
		int cur_type = 0;
		int cur_len = 0;
		while(msg_next(msg, &offset, &cur_key, &cur_type, &cur_len) != -1) {
			switch(cur_key) {
			case ENUM_ROOPKOTHA_GUI_CORE_TASK_GRAPHICS_TASK:
				perform_graphics_task(msg, &offset, &cur_key, &cur_type, &cur_len, &win);
				break;
			default:
				break;
			}
		}
		aroop_object_unref(aroop_txt_t*,0,msg);
		if(win)
			OPPUNREF(win);
	}
	return 0;
}

static int key_event_map(KeySym key) {
	int x = 0;
	switch(key) {
        case XK_Up:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_UP;
        break;
        case XK_Down:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_DOWN;
        break;
        case XK_Right:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_RIGHT;
        break;
        case XK_Left:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_LEFT;
        break;
        case XK_Linefeed:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_ENTER;
        break;
        case XK_Return:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_RETURN;
        break;
        case XK_F1:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_F1;
        break;
        case XK_F2:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_F2;
        break;
        case XK_Escape:
            x = ENUM_ROOPKOTHA_ACTION_INPUT_KEY_KEY_ESCAPE;
        break;
	default:
	break;
        }
	return x;
}

static int perform_x11_task() {
	if(XPending(gcore.disp) == 0)
		return 0;
  	XEvent myevent;
      	XNextEvent (gcore.disp, &myevent);
	switch (myevent.type)
	{
		case Expose:		/* Repaint window on expose */
		if (myevent.xexpose.count == 0) {
			//change_gc(myevent.xexpose.x, myevent.xexpose.y, myevent.xexpose.width, myevent.xexpose.height);
			repaint_x11();
		}
		break;
		case MappingNotify:	/* Process keyboard mapping changes: */
			XRefreshKeyboardMapping (&myevent.xmapping);
		break;
		case ConfigureNotify:
		{
			XConfigureEvent ev = myevent.xconfigure;
			if(ev.width != gcore.width || ev.height != gcore.height) {
				msg_enqueue(ENUM_ROOPKOTHA_GUI_CORE_TASK_WINDOW_TASK, ENUM_ROOPKOTHA_GUI_WINDOW_TASK_RESIZE
					, 3, gcore.wid, ev.width, ev.height);
			}
		}
		break;
#if 0
		case ResizeRequest:		/* Resize */
		{
			XResizeRequestEvent ev = myevent.xresizerequest;
			// TODO set the correct window id
			msg_enqueue(ENUM_ROOPKOTHA_GUI_CORE_TASK_WINDOW_TASK, ENUM_ROOPKOTHA_GUI_WINDOW_TASK_RESIZE, 3, 1, ev.width, ev.height);
			//set_clip(ev.window, ev.width, ev.height);
			repaint_x11();
		}
		break;
		case ButtonPress:	/* Process mouse click - output Hi! at mouse: */
		  XDrawImageString (myevent.xbutton.display, myevent.xbutton.window,
				    mygc, myevent.xbutton.x, myevent.xbutton.y, hi,
				    strlen (hi));
		  break;
#endif
		case KeyPress:		/* Process key press - quit on q: */
		{
			char text[10];
			KeySym skey = 0;
			XComposeStatus compose;
		  	int nChar = XLookupString (&myevent.xkey, text, 10, &skey, &compose);
			int i;
			int code = key_event_map(skey);
			if(code) {
				msg_enqueue(ENUM_ROOPKOTHA_GUI_CORE_TASK_WINDOW_TASK, ENUM_ROOPKOTHA_GUI_WINDOW_TASK_KEY_PRESS, 3, gcore.wid, 0, code);
			} else {
				for(i = 0; i < nChar; i++) 
					msg_enqueue(ENUM_ROOPKOTHA_GUI_CORE_TASK_WINDOW_TASK, ENUM_ROOPKOTHA_GUI_WINDOW_TASK_KEY_PRESS, 3, gcore.wid, text[i], code);
			}
		}
		break;
	}
	return 0;
}

static int perform_task() {
	aroop_txt_t*msg = NULL;
	x11_window_t*win = NULL;
	while((msg = (aroop_txt_t*)opp_dequeue(&gcore.incoming))) {
		int offset = 0;
		int cur_key = 0;
		int cur_type = 0;
		int cur_len = 0;
		while(msg_next(msg, &offset, &cur_key, &cur_type, &cur_len) != -1) {
			switch(cur_key) {
			case ENUM_ROOPKOTHA_GUI_CORE_TASK_WINDOW_TASK:
				perform_window_task(msg, &offset, &cur_key, &cur_type, &cur_len);
				break;
			case ENUM_ROOPKOTHA_GUI_CORE_TASK_GRAPHICS_TASK:
				perform_graphics_task(msg, &offset, &cur_key, &cur_type, &cur_len, &win);
				break;
			case ENUM_ROOPKOTHA_GUI_CORE_TASK_MISC_TASK:
				perform_misc_task(msg, &offset, &cur_key, &cur_type, &cur_len);
				break;
			default:
				break;
			}
		}
		aroop_object_unref(aroop_txt_t*,0,msg);
	}
	perform_x11_task();
	return 0;
}

int platform_impl_guicore_step(PlatformRoopkothaGUICore*UNUSED_VAR(nothing)) {
	perform_task();
	return 0;
}

int platform_impl_push_task(PlatformRoopkothaGUICore*UNUSED_VAR(nothing), aroop_txt_t*msg) {
	// copy to new text ..
	SYNC_ASSERT(msg != NULL);
	SYNC_ASSERT(msg->len != 0);
	aroop_txt_t*msgcp = aroop_txt_new_copy_on_demand(msg,0);
	SYNC_ASSERT(msgcp != NULL);
	opp_enqueue(&gcore.incoming, msgcp);
	aroop_object_unref(aroop_txt_t*,0,msgcp);
	return 0;
}

int platform_impl_pop_task_as(PlatformRoopkothaGUICore*UNUSED_VAR(nothing), aroop_txt_t*msg) {
	aroop_txt_t*outmsg = (aroop_txt_t*)opp_dequeue(&gcore.outgoing);
	if(!outmsg) return 0;
	aroop_txt_embeded_copy_on_demand(msg, outmsg);
	aroop_object_unref(aroop_txt_t*,0,outmsg);
	return 0;
}

C_CAPSULE_END
