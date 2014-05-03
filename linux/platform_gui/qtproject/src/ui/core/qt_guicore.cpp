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

#include "qt_guicore.h"

C_CAPSULE_START
#include "shotodol_watchdog.h"
#define watchdog_log_string(x) aroop_cl_shotodol_shotodol_watchdog_logString(__FILE__, __LINE__, 10 , x)

static QApplication*app;
QTRoopkothaGUICore*qt_impl_guicore_create() {
	char*argv[2] = {"yourapp", "man"};
	int argc = 1;
	watchdog_log_string("**************************Allocating new application**************\n");
	app = new QApplication(argc, argv);
	//watchdog_log_string(" argv0: %s\n", app->arguments().at(0).data());
	app->setAttribute(Qt::AA_ImmediateWidgetCreation); // This is important, otherwise the application gets crashed when we show window or something.
	return app;
}
void qt_impl_guicore_destroy(QTRoopkothaGUICore*UNUSED_VAR(ptr)) {
	delete app;
}

int qt_impl_guicore_step(QTRoopkothaGUICore*UNUSED_VAR(nothing)) {
  app->processEvents(0,100);
	return 0;
}

C_CAPSULE_END
