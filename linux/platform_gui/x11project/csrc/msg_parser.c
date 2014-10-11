
static int msg_write_int(aroop_txt_t*msg, int key, unsigned int val) {
	if((msg->size - msg->len) < 6) {
		return -1;
	}
	char*str = aroop_txt_to_string(msg);
	str[msg->len++] = (unsigned char)key;
	if(val >= 0xFFFF) {
		str[msg->len++] = /*(0<<6) |*/ 4; // 0 means numeral , 4 is the numeral size
		str[msg->len++] = (unsigned char)((val & 0xFF000000)>>24);
		str[msg->len++] = (unsigned char)((val & 0x00FF0000)>>16);
	} else {
		str[msg->len++] = /*(0<<6) |*/ 2; // 0 means numeral , 4 is the numeral size
	}
	str[msg->len++] = (unsigned char)((val & 0xFF00)>>8);
	str[msg->len++] = (unsigned char)(val & 0x00FF);
	return 0;
}

static int msg_next(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len) {
	if(*cur_len != 0) {
		*offset += *cur_len;
	}
	if(((*offset)+2) >= msg->len) {
		return -1;
	}
	char*str = aroop_txt_to_string(msg);
	*cur_key = str[*offset];
	*offset=*offset+1;
	*cur_type = (str[*offset] >> 6);
	*cur_len = (str[*offset] & 0x3F); //  b111111
	*offset=*offset+1;
	if(((*offset)+*cur_len) > msg->len) {
		return -1;
	}
	return *cur_key;
}

unsigned int msg_numeric_value(aroop_txt_t*msg, int*offset, int*cur_type, int*cur_len) {
	SYNC_ASSERT(*cur_type == 0); // we expect numeral value 
	unsigned int output = 0;
	char*str = aroop_txt_to_string(msg);
	if(*cur_len >= 1) {
		output = (unsigned char)str[*offset];
	}
	if(*cur_len >= 2) {
		output = output << 8;
		output |= ((unsigned char)str[*offset+1]) & 0xFF;
	}
	if(*cur_len >= 3) {
		output = output << 8;
		output |= ((unsigned char)str[*offset+2]) & 0xFF;
	}
	if(*cur_len == 4) {
		output = output << 8;
		output |= ((unsigned char)str[*offset+3]) & 0xFF;
	}
	return output;
}

static int msg_string_value(aroop_txt_t*msg, int*offset, int*cur_type, int*cur_len, aroop_txt_t*output) {
	SYNC_ASSERT(*cur_type == 1); // we expect string value
	if(*cur_len == 0) {
		aroop_txt_destroy(output);
		return 0;
	}
	aroop_txt_embeded_copy_on_demand(output,msg);
	aroop_txt_shift(output, *offset);
	char*str = aroop_txt_to_string(msg);
	if(str != NULL && str[*cur_len-1] == '\0') {
		aroop_txt_set_length(output, *cur_len - 1);
	} else {
		aroop_txt_set_length(output, *cur_len);
	}
	return 0;
}

static int msg_binary_value(aroop_txt_t*msg, int*offset, int*cur_type, int*cur_len, aroop_txt_t*output) {
	SYNC_ASSERT(*cur_type == 2); // we expect binary value
	if(*cur_len == 0) {
		aroop_txt_destroy(output);
		return 0;
	}
	aroop_txt_embeded_copy_on_demand(output,msg);
	aroop_txt_shift(output, *offset);
	aroop_txt_set_length(output, *cur_len);
	return 0;
}

static int msg_enqueue(int key, int type, int argc, ...) {
	aroop_txt_t*msg = aroop_txt_new_alloc(64, NULL);
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

