/*
 * qt_graphics.cpp
 *
 *  Created on: Jan 21, 2011
 *      Author: ayaskanti
 */
#include "core/config.h"
#include "core/decorator.h"
#include "core/txt.h"
//#include <QtCore>
#include <QPainter>
#include <QColor>
#include <QGraphicsView>
#include <QPixmap>
#include <QVariant>
#include "qt_graphics.h"


C_CAPSULE_START

void qt_impl_draw_image(QTRoopkothaGraphics*UNUSED_VAR(g), aroop_cl_onubodh_onubodh_raw_image*UNUSED_VAR(img), int UNUSED_VAR(x), int UNUSED_VAR(y), int UNUSED_VAR(anchor)) {
//			qtg->painter->drawImage(x, y, img->data);
}

void qt_impl_draw_line(QTRoopkothaGraphics*qtg, int x1, int y1, int x2, int y2) {
	qtg->painter->drawLine(x1, y1, x2, y2);
}

void qt_impl_draw_rect(QTRoopkothaGraphics*qtg, int x, int y, int width, int height) {
    qtg->painter->drawRect(x, y, width, height);
}

void qt_impl_draw_round_rect(QTRoopkothaGraphics*qtg, int x, int y, int width, int height, int arcWidth, int arcHeight) {
    qtg->painter->drawRoundedRect(x, y, width, height, arcWidth, arcHeight,  Qt::RelativeSize);
}

void qt_impl_draw_string(QTRoopkothaGraphics*qtg, struct aroop_txt*str, int x, int y, int width, int height, int anchor) {
	//GUI_LOG("Drawing string [%d]%s\n", str->len, str->str);
    QString text(str->str);
    int flags = 0;

    text.resize(str->len);
    if(anchor & ENUM_ROOPKOTHA_GRAPHICS_ANCHOR_TOP) {
    	flags |= Qt::AlignTop;
    }
    if(anchor & ENUM_ROOPKOTHA_GRAPHICS_ANCHOR_LEFT) {
    	flags |= Qt::AlignLeft;
    }
    if(anchor & ENUM_ROOPKOTHA_GRAPHICS_ANCHOR_RIGHT) {
		flags |= Qt::AlignRight;
	}
    if(anchor & ENUM_ROOPKOTHA_GRAPHICS_ANCHOR_HCENTER) {
    	flags |= Qt::AlignHCenter;
    }
    if(anchor & ENUM_ROOPKOTHA_GRAPHICS_ANCHOR_BOTTOM) {
    	flags |= Qt::AlignBottom;
    }
	qtg->painter->drawText(x, y, width, height, flags, text);
//    qtg->painter->drawText(x, y, text);
}

void qt_impl_fill_rect(QTRoopkothaGraphics*qtg, int x, int y, int width, int height) {
    qtg->painter->fillRect(x, y, width, height, *qtg->pen);
}

void qt_impl_fill_triangle(QTRoopkothaGraphics*UNUSED_VAR(gtg)
, int UNUSED_VAR(x1), int UNUSED_VAR(y1), int UNUSED_VAR(x2), int UNUSED_VAR(y2), int UNUSED_VAR(x3), int UNUSED_VAR(y3)) {
    // TODO fill me
    //qtg->painter->fillPath(qtg->path, NULL);
}

void qt_impl_fill_round_rect(QTRoopkothaGraphics*qtg, int x, int y, int width
		, int height, int UNUSED_VAR(arcWidth), int UNUSED_VAR(arcHeight)) {
    qtg->painter->fillRect(x, y, width, height, *qtg->pen);
}

void qt_impl_set_color(QTRoopkothaGraphics*qtg, int rgb) {
    //SYNC_LOG_OPP(&graphics_factory);
    //opp_callback2(g, OPPN_ACTION_VIEW, NULL);
	qtg->color = rgb;
    qtg->pen->setRgb(rgb);
    qtg->painter->setPen(*qtg->pen);
}

int qt_impl_get_color(QTRoopkothaGraphics*qtg) {
	return qtg->color;
}

void qt_impl_set_font(QTRoopkothaGraphics*qtg, QTRoopkothaFont*qtfont) {
    aroop_assert(qtfont);
    qtg->painter->setFont(qtfont->font);
}

void qt_impl_start(QTRoopkothaGraphics*qtg) {
    if(!qtg->painter->isActive()) {
        qtg->painter->begin(qtg->page);
    }
}

QTRoopkothaGraphics*qt_impl_graphics_create() {
	return new QTRoopkothaGraphics();
}

void qt_impl_graphics_destroy(QTRoopkothaGraphics*qtg) {
	//qtg->~QTRoopkothaGraphics();
	delete qtg;
}


C_CAPSULE_END

