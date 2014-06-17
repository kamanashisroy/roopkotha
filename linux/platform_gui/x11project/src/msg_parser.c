
static int msg_write_int(aroop_txt_t*msg, int key, unsigned int val) {
	if((msg->size - msg->len) < 6) {
		return -1;
	}
	msg->str[msg->len++] = (unsigned char)key;
	if(val >= 0xFFFF) {
		msg->str[msg->len++] = /*(0<<6) |*/ 4; // 0 means numeral , 4 is the numeral size
		msg->str[msg->len++] = (unsigned char)((val & 0xFF000000)>>24);
		msg->str[msg->len++] = (unsigned char)((val & 0x00FF0000)>>16);
	} else {
		msg->str[msg->len++] = /*(0<<6) |*/ 2; // 0 means numeral , 4 is the numeral size
	}
	msg->str[msg->len++] = (unsigned char)((val & 0xFF00)>>8);
	msg->str[msg->len++] = (unsigned char)(val & 0x00FF);
	return 0;
}

static int msg_next(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len) {
	if(*cur_len != 0) {
		*offset += *cur_len;
	}
	if(((*offset)+2) >= msg->len) {
		return -1;
	}
	*cur_key = msg->str[*offset];
	*offset=*offset+1;
	*cur_type = (msg->str[*offset] >> 6);
	*cur_len = (msg->str[*offset] & 0x3F); // 11000000 
	*offset=*offset+1;
	if(((*offset)+*cur_len) > msg->len) {
		return -1;
	}
	return *cur_key;
}

unsigned int msg_numeric_value(aroop_txt_t*msg, int*offset, int*cur_type, int*cur_len) {
	SYNC_ASSERT(*cur_type == 0); // we expect numeral value 
	unsigned int output = 0;
	if(*cur_len >= 1) {
		output = (unsigned char)msg->str[*offset];
	}
	if(*cur_len >= 2) {
		output = output << 8;
		output |= ((unsigned char)msg->str[*offset+1]) & 0xFF;
	}
	if(*cur_len >= 3) {
		output = output << 8;
		output |= ((unsigned char)msg->str[*offset+2]) & 0xFF;
	}
	if(*cur_len == 4) {
		output = output << 8;
		output |= ((unsigned char)msg->str[*offset+3]) & 0xFF;
	}
	return output;
}

static int msg_string_value(aroop_txt_t*msg, int*offset, int*cur_type, int*cur_len, aroop_txt_t*output) {
	SYNC_ASSERT(*cur_type == 1); // we expect string value
	int cmd = 0;
	if(*cur_len > 0) {
		output->str = msg->str+*offset;
	} else {
		output->str = NULL;
	}
	output->len = *cur_len;
	output->size = *cur_len;
	output->proto = NULL;
	return 0;
}

static int msg_binary_value(aroop_txt_t*msg, int*offset, int*cur_type, int*cur_len, aroop_txt_t*output) {
	SYNC_ASSERT(*cur_type == 1); // we expect string value
	int cmd = 0;
	if(*cur_len > 0) {
		output->str = msg->str+*offset;
	} else {
		output->str = NULL;
	}
	output->len = *cur_len;
	output->size = *cur_len;
	output->proto = NULL;
	return 0;
}

static int msg_enqueue(int key, int type, int argc, ...) {
	aroop_txt_t*msg = aroop_txt_new(NULL, 64, NULL, 0);
	msg->len = 0;
	msg_write_int(msg, key, type);
	va_list a_list;
    	va_start( a_list, argc );
	int i = 0;
	for (i = 0; i < argc; i++ ) {
        	int x = va_arg ( a_list, int ); 
		msg_write_int(msg, ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG, x);
	}
	va_end (a_list);
	opp_enqueue(&gcore.outgoing, msg);
}

static int msg_scan(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len, int argc, ...) {
	va_list a_list;
    	va_start( a_list, argc );
	int i = 0;
	for(i = 0; i < argc; i++) {
        	unsigned int *x = va_arg ( a_list, unsigned int* ); 
		SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
		SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
		*x = msg_numeric_value(msg, offset, cur_type, cur_len);
	}
	va_end (a_list);
}

