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
#include "core/config.h"
#include "core/decorator.h"

#include <X11/Xlib.h> 
#include <X11/Xutil.h>
#include "aroop_core.h"
#include "opp/opp_factory.h"
#include "core/txt.h"
#include "opp/opp_queue.h"
#include "shotodol_gui.h"
#include "shotodol_watchdog.h"
#define watchdog_log_string(x) aroop_cl_shotodol_shotodol_watchdog_logString(__FILE__, __LINE__, 10 , x)
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
};
static char*argv[2] = {"shotodol.bin", "man"};
static int argc = 1;
char*default_title = "Hello";
static struct x11_guicore gcore;
static int platform_window_init();
static int platform_window_deinit();

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
int perform_window_task(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len) {
	// check the task ..
	static int ready = 0;
	ready++;
	int cmd = msg_numeric_value(msg, offset, cur_type, cur_len);
	SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
	SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
	int wid = msg_numeric_value(msg, offset, cur_type, cur_len);
	Window pw = (Window)opp_indexed_list_get(&gcore.pwins, wid);
	GC gc = (GC)opp_indexed_list_get(&gcore.pgfx, wid);
	switch(cmd) {
	case ENUM_ROOPKOTHA_GUI_WINDOW_TASK_SHOW_WINDOW:
		if(pw == 0) {
			unsigned long mybackground = WhitePixel (gcore.disp, gcore.scrn);
 			unsigned long myforeground = BlackPixel (gcore.disp, gcore.scrn);
			//unsigned long mybackground = BlackPixel (gcore.disp, gcore.scrn);
 			//unsigned long myforeground = WhitePixel (gcore.disp, gcore.scrn);
  			XSizeHints myhint;
			/* Suggest where to position the window: */
			myhint.x = 200;
			myhint.y = 200;
			myhint.width = 300;
			myhint.height = 300;
			myhint.flags = PPosition | PSize;

			pw = XCreateSimpleWindow(gcore.disp, DefaultRootWindow(gcore.disp), myhint.x, myhint.y, myhint.width, myhint.height, 5, myforeground, mybackground);
			aroop_indexed_list_set(&gcore.pwins, wid, pw);
  			XSetStandardProperties (gcore.disp, pw, default_title, default_title, None, argv, argc, &myhint);
			if(gc == NULL) {
				gc = XCreateGC(gcore.disp, pw, 0, 0);
				aroop_indexed_list_set(&gcore.pgfx, wid, gc);
				XSetBackground (gcore.disp, gc, mybackground);
				XSetForeground (gcore.disp, gc, myforeground);	/* Select input devices to listen to: */
				XSelectInput (gcore.disp, pw, ResizeRedirectMask | ButtonPressMask | KeyPressMask | ExposureMask);	/* Actually display the window: */
				// display window
				XMapRaised (gcore.disp, pw);
				//XMapWindow(gcore.disp, pw);
				watchdog_log_string("Created new X11 window\n");
  				//XEvent myevent;XNextEvent (gcore.disp, &myevent); // this will render the window in effect
			}
		}
		watchdog_log_string("Show window\n");
		break;
	case ENUM_ROOPKOTHA_GUI_WINDOW_TASK_DESTROY:
		aroop_indexed_list_set(&gcore.pgfx, wid, NULL);
		if(gc != NULL) {
			// TODO destroy graphics
		}
		aroop_indexed_list_set(&gcore.pwins, wid, NULL);
		if(pw != NULL) {
			// TODO destroy window
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

static int platform_window_init() {
	OPP_INDEXED_LIST_CREATE2(&gcore.pwins, 2, OPPL_POINTER_NOREF);
	OPP_INDEXED_LIST_CREATE2(&gcore.pgfx, 2, OPPL_POINTER_NOREF);
	OPP_INDEXED_LIST_CREATE2(&gcore.layers, 2, 0);
	return 0;
}

static int platform_window_deinit() {
	// TODO destroy all the windows
	opp_factory_destroy(&gcore.pwins);
	opp_factory_destroy(&gcore.pgfx);
	opp_factory_destroy(&gcore.layers);
	return 0;
}

static int repaint_x11() {
	int i = 0;
	for(i = 0; i < 24; i++) {
		aroop_txt_t*msg = opp_indexed_list_get(&gcore.layers, i);
		if(!msg)continue;
		Window pw = 0;
		GC gc = 0;
		int offset = 0;
		int cur_key = 0;
		int cur_type = 0;
		int cur_len = 0;
		while(msg_next(msg, &offset, &cur_key, &cur_type, &cur_len) != -1) {
			switch(cur_key) {
			case ENUM_ROOPKOTHA_GUI_CORE_TASK_GRAPHICS_TASK:
				perform_graphics_task(msg, &offset, &cur_key, &cur_type, &cur_len, &pw, &gc);
				break;
			default:
				break;
			}
		}
		aroop_object_unref(aroop_txt_t*,0,msg);
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

/*
static int set_clip(Window w, int x, int y, int width, int height) {
	//XResizeWindow(gcore.disp, ev.window, ev.width, ev.height);
	GC wgc = (GC)opp_indexed_list_get(&gcore.pgfx, 1);
	Region r = XCreateRegion();
	XSetRegion(gcore.disp, wgc, r);
	XDestroyRegion(r);
}*/

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
		case ResizeRequest:		/* Resize */
		{
			XResizeRequestEvent ev = myevent.xresizerequest;
			// TODO set the correct window id
			msg_enqueue(ENUM_ROOPKOTHA_GUI_CORE_TASK_WINDOW_TASK, ENUM_ROOPKOTHA_GUI_WINDOW_TASK_RESIZE, 3, 1, ev.width, ev.height);
			//set_clip(ev.window, ev.width, ev.height);
			repaint_x11();
		}
		break;
#if 0
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
				// TODO set the correct window id
				msg_enqueue(ENUM_ROOPKOTHA_GUI_CORE_TASK_WINDOW_TASK, ENUM_ROOPKOTHA_GUI_WINDOW_TASK_KEY_PRESS, 3, 1, 0, code);
			} else {
				for(i = 0; i < nChar; i++) 
					msg_enqueue(ENUM_ROOPKOTHA_GUI_CORE_TASK_WINDOW_TASK, ENUM_ROOPKOTHA_GUI_WINDOW_TASK_KEY_PRESS, 3, 1, text[i], code);
			}
		}
		break;
	}
	return 0;
}

static int perform_task() {
	aroop_txt_t*msg = NULL;
	Window pw = 0;
	GC gc = 0;
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
				perform_graphics_task(msg, &offset, &cur_key, &cur_type, &cur_len, &pw, &gc);
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
	aroop_txt_t*msgcp = aroop_txt_clone_etxt(msg);
	SYNC_ASSERT(msgcp != NULL);
	opp_enqueue(&gcore.incoming, msgcp);
	aroop_object_unref(aroop_txt_t*,0,msgcp);
	return 0;
}

int platform_impl_pop_task_as(PlatformRoopkothaGUICore*UNUSED_VAR(nothing), aroop_txt_t*UNUSED_VAR(msg)) {
	aroop_txt_t*outmsg = (aroop_txt_t*)opp_dequeue(&gcore.outgoing);
	if(!outmsg) return 0;
	msg->str = outmsg->str;
	msg->len = outmsg->len;
	msg->hash = outmsg->hash;
	msg->proto = OPPREF(outmsg);
	aroop_object_unref(aroop_txt_t*,0,outmsg);
	return 0;
}

C_CAPSULE_END
