#ifndef QT_ROOPKOTHA_MESSAGE_H
#define QT_ROOPKOTHA_MESSAGE_H

#if 0
#include "core/config.h"
#include "core/decorator.h"
#include "core/txt.h"
#endif

C_CAPSULE_START
int perform_gui_task(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len);
// task message
int msg_next(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len);
int msg_numeric_value(aroop_txt_t*msg, int*offset, int*cur_type, int*cur_len);
int perform_window_task(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len);
C_CAPSULE_END

#endif // QT_ROOPKOTHA_MESSAGE_H
