/*
 * qt_graphics.h
 *
 *  Created on: Nov 28, 2011
 *      Author: kamanashisroy
 */

#ifndef QT_GRAPHICS_H_
#define QT_GRAPHICS_H_

#include "shotodol_gui.h"
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

void qt_impl_draw_image(QTRoopkothaGraphics*UNUSED_VAR(g), aroop_cl_onubodh_onubodh_raw_image*UNUSED_VAR(img), int UNUSED_VAR(x), int UNUSED_VAR(y), int UNUSED_VAR(anchor));
void qt_impl_draw_line(QTRoopkothaGraphics*g, int x1, int y1, int x2, int y2);
void qt_impl_draw_rect(QTRoopkothaGraphics*qtg, int x, int y, int width, int height);
void qt_impl_draw_round_rect(QTRoopkothaGraphics*qtg, int x, int y, int width, int height, int arcWidth, int arcHeight);
void qt_impl_draw_string(QTRoopkothaGraphics*qtg, struct aroop_txt*str, int x, int y, int width, int height, int anchor);
void qt_impl_fill_rect(QTRoopkothaGraphics*qtg, int x, int y, int width, int height);
void qt_impl_fill_triangle(QTRoopkothaGraphics*UNUSED_VAR(gtg)
, int UNUSED_VAR(x1), int UNUSED_VAR(y1), int UNUSED_VAR(x2), int UNUSED_VAR(y2), int UNUSED_VAR(x3), int UNUSED_VAR(y3));
void qt_impl_fill_round_rect(QTRoopkothaGraphics*qtg, int x, int y, int width
		, int height, int UNUSED_VAR(arcWidth), int UNUSED_VAR(arcHeight));
void qt_impl_set_color(QTRoopkothaGraphics*qtg, int rgb);
int qt_impl_get_color(QTRoopkothaGraphics*qtg);
void qt_impl_set_font(QTRoopkothaGraphics*qtg, QTRoopkothaFont*qtfont);
void qt_impl_start(QTRoopkothaGraphics*qtg);
QTRoopkothaGraphics*qt_impl_graphics_create();
void qt_impl_graphics_destroy(QTRoopkothaGraphics*qtg);

C_CAPSULE_END

#endif /* QT_GRAPHICS_H_ */
