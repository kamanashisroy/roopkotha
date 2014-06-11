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
 * qt_guicore.cpp
 *
 *  Created on: Jan 14, 2011
 *      Author: ayaskanti
 */
#include "core/config.h"
#include "core/decorator.h"
#include <QtGui>
C_CAPSULE_START
#include "core/txt.h"
#include "opp/opp_queue.h"
#include "shotodol_gui.h"
#include "shotodol_watchdog.h"
#define watchdog_log_string(x) aroop_cl_shotodol_shotodol_watchdog_logString(__FILE__, __LINE__, 10 , x)
C_CAPSULE_END
#include "qt_guicore.h"
#include "qt_window.h"
#include "qt_graphics.h"
#include "qt_message.h"


C_CAPSULE_START
static QApplication*app;
static opp_queue_t msgq;
static char*argv[2] = {"yourapp", "man"};
static int argc = 1;
QTRoopkothaGUICore*qt_impl_guicore_create() {
	watchdog_log_string("**************************Allocating new application**************\n");
	app = new QApplication(argc, argv);
	//watchdog_log_string(" argv0: %s\n", app->arguments().at(0).data());
	app->setAttribute(Qt::AA_ImmediateWidgetCreation); // This is important, otherwise the application gets crashed when we show window or something.
	opp_queue_init2(&msgq, 0);
	watchdog_log_string("Initiated queue\n");
	qt_window_init();
	return app;
}
void qt_impl_guicore_destroy(QTRoopkothaGUICore*UNUSED_VAR(ptr)) {
	qt_window_deinit();
	delete app;
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


static int perform_task() {
	aroop_txt_t*msg = NULL;
	//watchdog_log_string("Platform:see if there is any message\n");
	while((msg = (aroop_txt_t*)opp_dequeue(&msgq))) {
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

int qt_impl_guicore_step(QTRoopkothaGUICore*UNUSED_VAR(nothing)) {
	app->processEvents(0,100);
	perform_task();
	return 0;
}

int qt_impl_push_task(QTRoopkothaGUICore*UNUSED_VAR(nothing), aroop_txt_t*msg) {
	// copy to new text ..
	SYNC_ASSERT(msg != NULL);
	SYNC_ASSERT(msg->len != 0);
	aroop_txt_t*msgcp = aroop_txt_clone_etxt(msg);
	SYNC_ASSERT(msgcp != NULL);
	opp_enqueue(&msgq, msgcp);
	aroop_object_unref(aroop_txt_t*,0,msgcp);
	return 0;
}

int qt_impl_pop_task_as(QTRoopkothaGUICore*UNUSED_VAR(nothing), aroop_txt_t*UNUSED_VAR(msg)) {
	return 0;
}

C_CAPSULE_END
