#ifndef QT_GUICORE_H
#define QT_GUICORE_H

C_CAPSULE_START

typedef void QTRoopkothaGUICore;
int qt_impl_guicore_step(QTRoopkothaGUICore*qtgcore);
QTRoopkothaGUICore*qt_impl_guicore_create();
void qt_impl_guicore_destroy(QTRoopkothaGUICore*qtgcore);
int qt_impl_push_task(QTRoopkothaGUICore*UNUSED_VAR(nothing), aroop_txt_t*msg);
int qt_impl_pop_task_as(QTRoopkothaGUICore*UNUSED_VAR(nothing), aroop_txt_t*msg);

C_CAPSULE_END

#endif // QT_GUICORE_H
