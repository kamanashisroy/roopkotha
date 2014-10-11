

static int perform_misc_task(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len) {
	int cmd = msg_numeric_value(msg, offset, cur_type, cur_len);
	switch(cmd) {
	case ENUM_ROOPKOTHA_GUI_MISC_TASK_ECHO_MESSAGE:
		watchdog_log_string("Misc task: echo message\n");
		SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
		SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
		aroop_txt_t content;
		msg_string_value(msg, offset, cur_type, cur_len, &content);
		watchdog_log_string(aroop_txt_to_string(&content));
		break;
	default:
		watchdog_log_string("Misc task: Unknown\n");
	break;
	}
	return 0;
}


