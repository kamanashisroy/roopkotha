#ifndef QT_GUICORE_H
#define QT_GUICORE_H

C_CAPSULE_START

typedef void QTRoopkothaGUICore;
int qt_impl_guicore_step(QTRoopkothaGUICore*qtgcore);
QTRoopkothaGUICore*qt_impl_guicore_create();
void qt_impl_guicore_destroy(QTRoopkothaGUICore*qtgcore);

C_CAPSULE_END

#endif // QT_GUICORE_H
