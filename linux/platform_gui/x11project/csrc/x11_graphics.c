
static int perform_graphics_task(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len, x11_window_t**gwin) {
	// check the task ..
	int cmd = msg_numeric_value(msg, offset, cur_type, cur_len);
	x11_window_t*win = *gwin;
	switch(cmd) {
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_DRAW_IMAGE:
		{
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			aroop_txt_t img_data;
			msg_binary_value(msg, offset, cur_type, cur_len, &img_data);
			unsigned int x,y,anc;
			msg_scan(msg, offset, cur_key, cur_type, cur_len, 3, &x, &y, &anc);
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_DRAW_LINE:
		{
			unsigned int x1,x2,y1,y2;
			msg_scan(msg, offset, cur_key, cur_type, cur_len, 4, &x1, &y1, &x2, &y2);
	    		if(win) {
				XDrawLine (gcore.disp, win->w, win->gc, x1, y1, x2, y2);
			}
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_DRAW_RECT:
		{
			unsigned int x,y,width,height;
			msg_scan(msg, offset, cur_key, cur_type, cur_len, 4, &x, &y, &width, &height);
	    		if(win) {
				XDrawRectangle (gcore.disp, win->w, win->gc, x, y, width, height);
			}
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_DRAW_ROUND_RECT:
		{
			int x,y,width,height,arcWidth,arcHeight;
			msg_scan(msg, offset, cur_key, cur_type, cur_len, 6, &x, &y, &width, &height, &arcWidth, &arcHeight);
	    		if(win) {
				XDrawRectangle (gcore.disp, win->w,win->gc, x, y, width, height);
			}
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_FILL_RECT:
		{
			unsigned int x,y,width,height;
			msg_scan(msg, offset, cur_key, cur_type, cur_len, 4, &x, &y, &width, &height);
	    		if(win) {
				XFillRectangle (gcore.disp, win->w,win->gc, x, y, width, height);
			}
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_FILL_ROUND_RECT:
		{
			int x,y,width,height,arcWidth,arcHeight;
			msg_scan(msg, offset, cur_key, cur_type, cur_len, 6, &x, &y, &width, &height, &arcWidth, &arcHeight);
	    		if(win) {
				XFillRectangle (gcore.disp, win->w,win->gc, x, y, width, height);
			}
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_FILL_TRIANGLE:
		{
			int x1,y1,x2,y2,x3,y3;
			msg_scan(msg, offset, cur_key, cur_type, cur_len, 6, &x1, &y1, &x2, &y2, &x3, &y3);
			// TODO draw line
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_DRAW_STRING:
		{
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			aroop_txt_t content;
			msg_string_value(msg, offset, cur_type, cur_len, &content);
			int x,y,width,height,anc;
			msg_scan(msg, offset, cur_key, cur_type, cur_len, 5, &x, &y, &width, &height, &anc);
	    		if(!win) {
				break;
			}
			int xpos = x;
			if(anc & ENUM_ROOPKOTHA_GRAPHICS_ANCHOR_RIGHT) {
				xpos = x+width-5*content.len;
			}
			int ypos = y+10;
			if(anc & ENUM_ROOPKOTHA_GRAPHICS_ANCHOR_BOTTOM) {
				ypos = y+height;
			}
			XDrawString (gcore.disp, win->w,win->gc, xpos, ypos, content.str, content.len);
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_SET_COLOR: // TODO abolish this task
		{
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			unsigned int rgb = msg_numeric_value(msg, offset, cur_type, cur_len);
	    		if(!win) {
				break;
			}
			Colormap colormap;
			colormap = DefaultColormap(gcore.disp, gcore.scrn);
			XColor rgbc;
#define RGBC rgbc
//#define RGBC gcore.rgbc
			unsigned char red = ((rgb & 0XFF0000)>>16) & 0xFF;
			unsigned char green = ((rgb & 0XFF00)>>8) & 0xFF;
			unsigned char blue = rgb & 0XFF;
			char spec[32];
			snprintf(spec, 32, "#%02x%02x%02x", red, green, blue);
			XParseColor (gcore.disp, colormap, spec, &RGBC);
			XAllocColor(gcore.disp, colormap, &RGBC);
			// TODO free color !
			XSetForeground (gcore.disp, win->gc, RGBC.pixel);
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_SET_FONT: // TODO abolish this task
		{
			SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
			SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
			int fontid = msg_numeric_value(msg, offset, cur_type, cur_len);
			// TODO set font
			break;
		}
	case ENUM_ROOPKOTHA_GRAPHICS_TASKS_START_LAYER:
		{
			int wid,layer;
			msg_scan(msg, offset, cur_key, cur_type, cur_len, 2, &wid, &layer);
			win = get_window(wid);
			*gwin = win;
			// save the layer
			aroop_txt_t*oldTasks = opp_indexed_list_get(&gcore.layers, layer);
			if(oldTasks != msg) {
				opp_indexed_list_set(&gcore.layers, layer, msg);
			}
			if(oldTasks) {
				aroop_object_unref(aroop_txt_t*,0,oldTasks);
			}
			break;
		}
	}
	return 0;
}


