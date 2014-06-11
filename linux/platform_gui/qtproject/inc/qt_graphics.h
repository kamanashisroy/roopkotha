/*
 * qt_graphics.h
 *
 *  Created on: Nov 28, 2011
 *      Author: kamanashisroy
 */

#ifndef QT_GRAPHICS_H_
#define QT_GRAPHICS_H_

#include "core/config.h"
#include "core/decorator.h"
#include "qt_font.h"

#ifdef __cplusplus
#include <QPainter>
#include <QColor>
#include <QGraphicsView>
#include <QPixmap>
#include <QVariant>

class QTRoopkothaGraphics {
public:
	QTRoopkothaGraphics() {
		pen = new QColor();
		page = new QPixmap(200,400);
		painter = new QPainter(page);
	}
	~QTRoopkothaGraphics() {
		if(painter)delete painter;
		if(pen)delete pen;
		if(page)delete page;
	}
public:
	QPainter*painter;
	QColor*pen;
	QPixmap*page;
	int color;
};
#else
typedef void QTRoopkothaGraphics;
#endif

C_CAPSULE_START

void qt_impl_start(QTRoopkothaGraphics*qtg);
QTRoopkothaGraphics*qt_impl_graphics_create();
void qt_impl_graphics_destroy(QTRoopkothaGraphics*qtg);

C_CAPSULE_END

#endif /* QT_GRAPHICS_H_ */
