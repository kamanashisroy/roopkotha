#ifndef MINIMAL_GUICORE_H
#define MINIMAL_GUICORE_H

typedef void PlatformRoopkothaGUICore;
int platform_impl_guicore_step(PlatformRoopkothaGUICore*UNUSED_VAR(nothing));
PlatformRoopkothaGUICore*UNUSED_VAR(nothing) platform_impl_guicore_create();
int platform_impl_guicore_destroy(PlatformRoopkothaGUICore*UNUSED_VAR(nothing));
int platform_impl_push_task(PlatformRoopkothaGUICore*UNUSED_VAR(nothing), aroop_txt_t*msg);
int platform_impl_pop_task_as(PlatformRoopkothaGUICore*UNUSED_VAR(nothing), aroop_txt_t*UNUSED_VAR(msg));

// task message
int msg_next(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len);
int msg_numeric_value(aroop_txt_t*msg, int*offset, int*cur_type, int*cur_len);

#endif // MINIMAL_GUICORE_H
