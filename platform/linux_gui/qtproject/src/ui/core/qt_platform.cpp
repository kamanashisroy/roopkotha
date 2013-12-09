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
 * qt_window.cpp
 *
 *  Created on: Jan 14, 2011
 *      Author: ayaskanti
 */
#include "core/config.h"
#include "core/decorator.h"
#include <QtGui>

#include "qt_guicore.h"

C_CAPSULE_START

static QApplication*app;
int qt_impl_guicore_init(void*UNUSED_VAR(nothing), int*argc, char *argv[]) {
    app = new QApplication(*argc, argv);
    return 0;
}

int qt_impl_guicore_step(void*UNUSED_VAR(nothing)) {
    app->processEvents(0,100);
	return 0;
}

C_CAPSULE_END
