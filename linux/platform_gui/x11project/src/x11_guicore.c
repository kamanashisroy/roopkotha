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
	GC gc;
  	int scrn;
	opp_factory_t pwins;
	opp_factory_t pgfx;
	opp_queue_t msgq;
};
static char*argv[2] = {"yourapp", "man"};
static int argc = 1;
static struct x11_guicore gcore;
static int platform_window_init();
static int platform_window_deinit();

PlatformRoopkothaGUICore*platform_impl_guicore_create() {
	memset(&gcore, 0, sizeof(gcore));
	watchdog_log_string("**************************Allocating new application**************\n");
	opp_queue_init2(&gcore.msgq, 0);
	watchdog_log_string("Initiated queue\n");
	platform_window_init();
	gcore.disp = XOpenDisplay("Fine");
	gcore.scrn = DefaultScreen(gcore.disp);
	return &gcore;
}

int platform_impl_guicore_destroy(PlatformRoopkothaGUICore*UNUSED_VAR(nothing)) {
	platform_window_deinit();
	return 0;
}

int msg_next(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len) {
	if(*cur_len != 0) {
		*offset += *cur_len;
	}
	if(((*offset)+2) >= msg->len) {
		return -1;
	}
	*cur_key = msg->str[*offset];
	*offset=*offset+1;
	*cur_type = (msg->str[*offset] >> 6);
	*cur_len = (msg->str[*offset] & 0x3F); // 11000000 
	*offset=*offset+1;
	if(((*offset)+*cur_len) > msg->len) {
		return -1;
	}
	return *cur_key;
}

int msg_numeric_value(aroop_txt_t*msg, int*offset, int*cur_type, int*cur_len) {
	SYNC_ASSERT(*cur_type == 0); // we expect numeral value 
	int cmd = 0;
	if(*cur_len == 1) {
		cmd = msg->str[*offset];
	}
	if(*cur_len == 2) {
		cmd = msg->str[*offset+0];
		cmd = cmd << 8;
		cmd |= msg->str[*offset+1];
	}
	if(*cur_len == 4) {
		cmd = msg->str[*offset+0];
		cmd = cmd << 8;
		cmd |= msg->str[*offset+1];
		cmd = cmd << 8;
		cmd |= msg->str[*offset+2];
		cmd = cmd << 8;
		cmd |= msg->str[*offset+3];
	}
	return cmd;
}

int perform_window_task(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len) {
	// check the task ..
	static int ready = 0;
	ready++;
	int cmd = msg_numeric_value(msg, offset, cur_type, cur_len);
	printf("msglen:%d, offset %d, key length %d\n", msg->len, *offset, *cur_len);
	SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
	SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
	int wid = msg_numeric_value(msg, offset, cur_type, cur_len);
	Window pw = (Window)opp_indexed_list_get(&gcore.pwins, wid);
	GC gc = (GC)opp_indexed_list_get(&gcore.pgfx, wid);
	switch(cmd) {
	case ENUM_ROOPKOTHA_GUI_WINDOW_TASK_SHOW_WINDOW:
		if(pw == NULL) {
			unsigned long mybackground = WhitePixel (gcore.disp, gcore.scrn);
 			unsigned long myforeground = BlackPixel (gcore.disp, gcore.scrn);
  			XSizeHints myhint;
			/* Suggest where to position the window: */
			myhint.x = 200;
			myhint.y = 200;
			myhint.width = 300;
			myhint.height = 300;
			myhint.flags = PPosition | PSize;

			pw = XCreateSimpleWindow(gcore.disp, DefaultRootWindow(pw), myhint.x, myhint.y, myhint.width, myhint.height, 5, myforeground, mybackground);
			aroop_indexed_list_set(&gcore.pwins, wid, pw);
			char*title = "Hello";
  			XSetStandardProperties (gcore.disp, pw, title, title, None, argv, argc, &myhint);
			watchdog_log_string("Created new window\n");
			if(gc == NULL) {
				gc = XCreateGC(gcore.disp, pw, 0, 0);
				aroop_indexed_list_set(&gcore.pgfx, wid, gc);
				XSetBackground (gcore.disp, gc, mybackground);
				XSetForeground (gcore.disp, gc, myforeground);	/* Select input devices to listen to: */
				XSelectInput (gcore.disp, pw, ButtonPressMask | KeyPressMask | ExposureMask);	/* Actually display the window: */
				XMapRaised (gcore.disp, pw);
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
	return 0;
}

static int platform_window_deinit() {
	// TODO destroy all the windows
	opp_factory_destroy(&gcore.pwins);
	opp_factory_destroy(&gcore.pgfx);
	return 0;
}



static int perform_task() {
	aroop_txt_t*msg = NULL;
	//watchdog_log_string("Platform:see if there is any message\n");
	while((msg = (aroop_txt_t*)opp_dequeue(&gcore.msgq))) {
		watchdog_log_string("Platform:There is message\n");
		int offset = 0;
		int cur_key = 0;
		int cur_type = 0;
		int cur_len = 0;
		while(msg_next(msg, &offset, &cur_key, &cur_type, &cur_len) != -1) {
			watchdog_log_string("Platform:Parsing messag, see what we need to do\n");
			switch(cur_key) {
			case ENUM_ROOPKOTHA_GUI_CORE_TASK_WINDOW_TASK:
				watchdog_log_string("Platform:window task\n");
				perform_window_task(msg, &offset, &cur_key, &cur_type, &cur_len);
				break;
			case ENUM_ROOPKOTHA_GUI_CORE_TASK_GRAPHICS_TASK:
				watchdog_log_string("Platform:graphics task\n");
				perform_gui_task(msg, &offset, &cur_key, &cur_type, &cur_len);
				break;
			default:
				break;
			}
		}
		aroop_object_unref(aroop_txt_t*,0,msg);
	}
	return 0;
}

int platform_impl_guicore_step(PlatformRoopkothaGUICore*UNUSED_VAR(nothing)) {
	perform_task();
#if 0
	while (done == 0) {
		XNextEvent (mydisplay, &myevent);
		switch (myevent.type)
		{
			case Expose:		/* Repaint window on expose */
			  if (myevent.xexpose.count == 0)
			    XDrawImageString (myevent.xexpose.display, myevent.xexpose.window,
					      mygc, 50, 50, hello, strlen (hello));
			  break;
			case MappingNotify:	/* Process keyboard mapping changes: */
			  XRefreshKeyboardMapping (&myevent);
			  break;
			case ButtonPress:	/* Process mouse click - output Hi! at mouse: */

			  XDrawImageString (myevent.xbutton.display, myevent.xbutton.window,
					    mygc, myevent.xbutton.x, myevent.xbutton.y, hi,
					    strlen (hi));
			  break;
			case KeyPress:		/* Process key press - quit on q: */
			  i = XLookupString (&myevent, text, 10, &mykey, 0);
			  if (i == 1 && text[0] == 'q')
			    done = 1;
			  break;
			}
		}
	}
#endif
	return 0;
}

int platform_impl_push_task(PlatformRoopkothaGUICore*UNUSED_VAR(nothing), aroop_txt_t*msg) {
	// copy to new text ..
	SYNC_ASSERT(msg != NULL);
	SYNC_ASSERT(msg->len != 0);
	aroop_txt_t*msgcp = aroop_txt_clone_etxt(msg);
	SYNC_ASSERT(msgcp != NULL);
	opp_enqueue(&gcore.msgq, msgcp);
	aroop_object_unref(aroop_txt_t*,0,msgcp);
	return 0;
}

int platform_impl_pop_task_as(PlatformRoopkothaGUICore*UNUSED_VAR(nothing), aroop_txt_t*UNUSED_VAR(msg)) {
	return 0;
}

C_CAPSULE_END
