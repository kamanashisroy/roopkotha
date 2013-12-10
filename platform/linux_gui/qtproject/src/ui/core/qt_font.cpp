
#include "core/config.h"
#include "core/decorator.h"
#include "core/txt.h"
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

#if false
static struct xultb_font*some_default_font = NULL;
struct xultb_font*xultb_font_get(int UNUSED_VAR(face), int UNUSED_VAR(style), int UNUSED_VAR(size)) {
	if(!some_default_font) {
		some_default_font = xultb_font_create();
	}
	return some_default_font;
}

int xultb_font_get_face(struct xultb_font*UNUSED_VAR(font)) {
	// TODO implement me
	return 0;
}
int xultb_font_get_style(struct xultb_font*UNUSED_VAR(font)) {
	// TODO implement me
	return 0;
}
int xultb_font_get_size(struct xultb_font*UNUSED_VAR(font)) {
	// TODO implement me
	return 0;
}
#endif

C_CAPSULE_END

