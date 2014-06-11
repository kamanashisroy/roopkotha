
#include "core/config.h"
#include "core/decorator.h"
C_CAPSULE_START
#include "core/txt.h"
#include "opp/opp_queue.h"
#include "shotodol_watchdog.h"
#define watchdog_log_string(x) aroop_cl_shotodol_shotodol_watchdog_logString(__FILE__, __LINE__, 10 , x)
C_CAPSULE_END
#include <QtGui>
#include <QFont>
#include <QFontMetrics>
#include "qt_font.h"

C_CAPSULE_START


int qt_impl_font_get_height(QTRoopkothaFont*qtfont) {
    return qtfont->metrics.height();
}

int qt_impl_font_get_substring_width(QTRoopkothaFont*qtfont, struct aroop_txt*str, int offset, int width) {
    QString text(str->str+offset);
    return qtfont->metrics.width(text, width);
}

QTRoopkothaFont*qt_impl_font_create() {
	return new QTRoopkothaFont();
}

void qt_impl_font_destroy(QTRoopkothaFont*qtfont) {
	//qtfont->~QTRoopkothaFont();
	delete qtfont;
}

/*
		UNDERLINED = 1,
		BOLD = (1 << 1),
		ITALIC = (1 << 2),
		PLAIN = (1 << 3),
		SMALL = (1 << 4),
		MEDIUM = (1 << 5),
		LARGE = (1 << 6),
	
*/
QTRoopkothaFont*qt_impl_font_get_variant(QTRoopkothaFont*qtfont, int variant) {
	QFont newFont(qtfont->font);
	if(variant & 1) {
		newFont.setUnderline(true);
	}
	if(variant & (1<<1)) {
		newFont.setBold(true);
	}
	if(variant & (1<<2)) {
		newFont.setItalic(true);
	}
	if(variant & (1<<4)) {
		newFont.setPixelSize(12);
	}
	if(variant & (1<<5)) {
		newFont.setPixelSize(15);
	}
	if(variant & (1<<6)) {
		newFont.setPixelSize(18);
	}
	return new QTRoopkothaFont(newFont);
}
#if false
static struct xultb_font*some_default_font = NULL;
struct xultb_font*xultb_font_get(int UNUSED_VAR(face), int UNUSED_VAR(style), int UNUSED_VAR(size)) {
	if(!some_default_font) {
		some_default_font = xultb_font_create();
	}
	return some_default_font;
}

#endif

C_CAPSULE_END

