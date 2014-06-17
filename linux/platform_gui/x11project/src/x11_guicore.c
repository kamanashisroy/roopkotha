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


static int msg_write_int(aroop_txt_t*msg, int key, int val) {
	if((msg->size - msg->len) < 6) {
		return -1;
	}
	msg->str[msg->len++] = (unsigned char)key;
	if(val >= 0xFFFF) {
		msg->str[msg->len++] = /*(0<<6) |*/ 4; // 0 means numeral , 4 is the numeral size
		msg->str[msg->len++] = (unsigned char)((val & 0xFF000000)>>24);
		msg->str[msg->len++] = (unsigned char)((val & 0x00FF0000)>>16);
	} else {
		msg->str[msg->len++] = /*(0<<6) |*/ 2; // 0 means numeral , 4 is the numeral size
	}
	msg->str[msg->len++] = (unsigned char)((val & 0xFF00)>>8);
	msg->str[msg->len++] = (unsigned char)(val & 0x00FF);
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
	if(*cur_len >= 1) {
		cmd = msg->str[*offset];
	}
	if(*cur_len >= 2) {
		cmd = cmd << 8;
		cmd |= msg->str[*offset+1];
	}
	if(*cur_len >= 3) {
		cmd = cmd << 8;
		cmd |= msg->str[*offset+2];
	}
	if(*cur_len == 4) {
		cmd = cmd << 8;
		cmd |= msg->str[*offset+3];
	}
	return cmd;
}

int msg_string_value(aroop_txt_t*msg, int*offset, int*cur_type, int*cur_len, aroop_txt_t*output) {
	SYNC_ASSERT(*cur_type == 1); // we expect string value
	int cmd = 0;
	if(*cur_len > 0) {
		output->str = msg->str+*offset;
	} else {
		output->str = NULL;
	}
	output->len = *cur_len;
	output->size = *cur_len;
	output->proto = NULL;
	return 0;
}

int msg_binary_value(aroop_txt_t*msg, int*offset, int*cur_type, int*cur_len, aroop_txt_t*output) {
	SYNC_ASSERT(*cur_type == 1); // we expect string value
	int cmd = 0;
	if(*cur_len > 0) {
		output->str = msg->str+*offset;
	} else {
		output->str = NULL;
	}
	output->len = *cur_len;
	output->size = *cur_len;
	output->proto = NULL;
	return 0;
}


int perform_graphics_task(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len, Window*win, GC*gc) {
	// check the task ..
	int cmd = msg_numeric_value(msg, offset, cur_type, cur_len);
	//printf("msglen:%d, offset %d, key length %d\n", msg->len, *offset, *cur_len);
	switch(cmd) {
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_DRAW_IMAGE:
		{
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			aroop_txt_t img_data;
			msg_binary_value(msg, offset, cur_type, cur_len, &img_data);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int x = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int y = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int anc = msg_numeric_value(msg, offset, cur_type, cur_len);
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_DRAW_LINE:
		{
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int x1 = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int y1 = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int x2 = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int y2 = msg_numeric_value(msg, offset, cur_type, cur_len);
	    		if(*win != NULL) {
				XDrawLine (gcore.disp, *win,*gc, x1, y1, x2, y2);
			}
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_DRAW_RECT:
		{
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int x = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int y = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int width = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int height = msg_numeric_value(msg, offset, cur_type, cur_len);
	    		if(*win != NULL) {
				XDrawRectangle (gcore.disp, *win,*gc, x, y, width, height);
			}
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_DRAW_ROUND_RECT:
		{
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int x = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int y = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int width = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int height = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int arcWidth = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int arcHeight = msg_numeric_value(msg, offset, cur_type, cur_len);
	    		if(*win != NULL) {
				XDrawRectangle (gcore.disp, *win,*gc, x, y, width, height);
			}
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_FILL_RECT:
		{
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int x = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int y = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int width = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int height = msg_numeric_value(msg, offset, cur_type, cur_len);
	    		if(*win != NULL) {
				XFillRectangle (gcore.disp, *win,*gc, x, y, width, height);
			}
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_FILL_ROUND_RECT:
		{
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int x = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int y = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int width = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int height = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int arcWidth = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int arcHeight = msg_numeric_value(msg, offset, cur_type, cur_len);
	    		if(*win != NULL) {
				XFillRectangle (gcore.disp, *win,*gc, x, y, width, height);
			}
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_FILL_TRIANGLE:
		{
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int x1 = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int y1 = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int x2 = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int y2 = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int x3 = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int y3 = msg_numeric_value(msg, offset, cur_type, cur_len);
			// TODO draw line
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_DRAW_STRING:
		{
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			aroop_txt_t content;
			msg_string_value(msg, offset, cur_type, cur_len, &content);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int x = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int y = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int width = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int height = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int anc = msg_numeric_value(msg, offset, cur_type, cur_len);
	    		if(*win != NULL) {
				watchdog_log_string("Rendering string\n");
				//printf("text at %d,%d\n", x, y);
				XDrawImageString (gcore.disp, *win,*gc, x+10, y+10, content.str, content.len);
			}
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_SET_COLOR: // TODO abolish this task
		{
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int rgb = msg_numeric_value(msg, offset, cur_type, cur_len);
	    		if(*win != NULL) {
				//XSetForeground (gcore.disp, *gc, rgb);
			}
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_SET_FONT: // TODO abolish this task
		{
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int fontid = msg_numeric_value(msg, offset, cur_type, cur_len);
			// TODO set font
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_START_LAYER:
		{
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int wid = msg_numeric_value(msg, offset, cur_type, cur_len);
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int layer = msg_numeric_value(msg, offset, cur_type, cur_len);
			Window pw = (Window)opp_indexed_list_get(&gcore.pwins, wid);
			GC wgc = (GC)opp_indexed_list_get(&gcore.pgfx, wid);
			*win = pw;
			*gc = wgc;
			// save the layer
			aroop_txt_t*oldTasks = opp_indexed_list_get(&gcore.layers, layer);
			if(oldTasks != msg) {
				opp_indexed_list_set(&gcore.layers, layer, msg);
			}
			if(oldTasks) {
				aroop_object_unref(aroop_txt_t*,0,oldTasks);
			}
			break;
		}
	}
	return 0;
}

int perform_window_task(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len) {
	// check the task ..
	static int ready = 0;
	ready++;
	int cmd = msg_numeric_value(msg, offset, cur_type, cur_len);
	//printf("msglen:%d, offset %d, key length %d\n", msg->len, *offset, *cur_len);
	SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
	SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
	int wid = msg_numeric_value(msg, offset, cur_type, cur_len);
	Window pw = (Window)opp_indexed_list_get(&gcore.pwins, wid);
	GC gc = (GC)opp_indexed_list_get(&gcore.pgfx, wid);
	switch(cmd) {
	case ENUM_ROOPKOTHA_GUI_WINDOW_TASK_SHOW_WINDOW:
		if(pw == 0) {
			//unsigned long mybackground = WhitePixel (gcore.disp, gcore.scrn);
 			//unsigned long myforeground = BlackPixel (gcore.disp, gcore.scrn);
			unsigned long mybackground = BlackPixel (gcore.disp, gcore.scrn);
 			unsigned long myforeground = WhitePixel (gcore.disp, gcore.scrn);
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
				XMapRaised (gcore.disp, pw);
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

static int msg_enqueue(int key, int type, int argc, ...) {
	aroop_txt_t*msg = aroop_txt_new(NULL, 64, NULL, 0);
	msg->len = 0;
	msg_write_int(msg, key, type);
	va_list a_list;
    	va_start( a_list, argc );
	int i = 0;
	for (i = 0; i < argc; i++ ) {
        	int x = va_arg ( a_list, int ); 
		msg_write_int(msg, ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG, x);
	}
	va_end (a_list);
	opp_enqueue(&gcore.outgoing, msg);
}

static int perform_x11_task() {
	if(XPending(gcore.disp) == 0)
		return 0;
  	XEvent myevent;
      	XNextEvent (gcore.disp, &myevent);
	switch (myevent.type)
	{
		case Expose:		/* Repaint window on expose */
			if (myevent.xexpose.count == 0)
				repaint_x11();
		break;
		case MappingNotify:	/* Process keyboard mapping changes: */
			XRefreshKeyboardMapping (&myevent.xmapping);
		break;
		case ResizeRequest:
		{
			XResizeRequestEvent ev = myevent.xresizerequest;
			// TODO set the correct window id
			msg_enqueue(ENUM_ROOPKOTHA_GUI_CORE_TASK_WINDOW_TASK, ENUM_ROOPKOTHA_GUI_WINDOW_TASK_RESIZE, 3, 1, ev.width, ev.height);
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
		  	int nChar = XLookupString (&myevent, text, 10, &skey, &compose);
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
