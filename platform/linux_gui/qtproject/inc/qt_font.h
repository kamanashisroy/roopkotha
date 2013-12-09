#ifndef QT_FONT_H
#define QT_FONT_H

#include <QFont>
#include <QFontMetrics>

class QTRoopkothaFont {
public:
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
C_CAPSULE_START
int qt_impl_font_get_height(QTRoopkothaFont*qtfont);
int qt_impl_font_get_substring_width(QTRoopkothaFont*qtfont, struct aroop_txt*str, int offset, int width);
void qt_impl_font_create(QTRoopkothaFont*qtfont);
void qt_impl_font_destroy(QTRoopkothaFont*qtfont);
C_CAPSULE_END
#endif // QT_FONT_H
