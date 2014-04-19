#ifndef QT_FONT_H
#define QT_FONT_H

#ifdef __cplusplus
#include <QFont>
#include <QFontMetrics>
class QTRoopkothaFont {
public:
    QTRoopkothaFont(QFont&given):font(given),metrics(given) {
		}
    QTRoopkothaFont():metrics(font) {
        //new (&font) QFont();
        //new (&metrics) QFontMetrics(font);
    }
    ~QTRoopkothaFont() {
    }
public:
    QFont font;
    QFontMetrics metrics;
};
#else
typedef void QTRoopkothaFont;
#endif

C_CAPSULE_START

int qt_impl_font_get_height(QTRoopkothaFont*qtfont);
int qt_impl_font_get_substring_width(QTRoopkothaFont*qtfont, struct aroop_txt*str, int offset, int width);
QTRoopkothaFont*qt_impl_font_create();
void qt_impl_font_destroy(QTRoopkothaFont*qtfont);
QTRoopkothaFont*qt_impl_font_get_variant(QTRoopkothaFont*qtfont, int variant);

C_CAPSULE_END


#endif // QT_FONT_H
