

static x11_window_t*create_window(Display*disp, Window root, int wid) {
	x11_window_t*win = (x11_window_t*)opp_str2_alloc(sizeof(x11_window_t));
	win->black_pixel = WhitePixel (gcore.disp, gcore.scrn);
 	win->white_pixel = BlackPixel (gcore.disp, gcore.scrn);
	win->title = "great";
	/* Suggest where to position the window: */
  	XSizeHints myhint;
	myhint.x = 200,myhint.y = 200;
	myhint.width = win->width = 200;
	myhint.height = win->height = 200;
	myhint.flags = PPosition | PSize;
	win->w = XCreateSimpleWindow(
		disp
		, root
		, 200, 200
		, win->width, win->height
		, 5 /* border width */
		, win->black_pixel/*foreground*/, win->white_pixel /*background*/
	);
	aroop_indexed_list_set(&gcore.pwins, wid, win);
	XSetStandardProperties (disp, win->w, win->title, win->title, None, argv, argc, &myhint);
	win->gc = XCreateGC(disp, win->w, 0, 0);
	XSetBackground (disp, win->gc, win->white_pixel);
	XSetForeground (disp, win->gc, win->black_pixel);
	/* Select input devices to listen to: */
	XSelectInput (disp, win->w, StructureNotifyMask | ButtonPressMask | KeyPressMask | ExposureMask);
	// display window
	XMapRaised (disp, win->w);
	//XMapWindow(disp, win->w);
	watchdog_log_string("Created new X11 window\n");
	return win;
}

static x11_window_t*get_window(int wid) {
	return opp_indexed_list_get(&gcore.pwins, wid);
}

static int perform_window_task(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len) {
	// check the task ..
	static int ready = 0;
	ready++;
	int cmd = msg_numeric_value(msg, offset, cur_type, cur_len);
	SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
	SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
	int wid = msg_numeric_value(msg, offset, cur_type, cur_len);
	x11_window_t*win = get_window(wid);
	switch(cmd) {
	case ENUM_ROOPKOTHA_GUI_WINDOW_TASK_SHOW_WINDOW:
		if(win == NULL) {
			win = create_window(gcore.disp, RootWindow (gcore.disp, gcore.scrn), wid);
		}
		watchdog_log_string("Show window\n");
		break;
	case ENUM_ROOPKOTHA_GUI_WINDOW_TASK_DESTROY:
		aroop_indexed_list_set(&gcore.pwins, wid, NULL);
		if(win != NULL) {
			// TODO destroy window
		}
	break;
#if 0
	case ENUM_ROOPKOTHA_GUI_WINDOW_TASK_PAINT_COMPLETE:
		qw->setPage(qtg->page);
		qtg->painter->end();
		qw->repaint();
	break;
#endif
	}
	if(win)
		OPPUNREF(win);
	return 0;
}

static int platform_window_init() {
	OPP_INDEXED_LIST_CREATE2(&gcore.pwins, 2, 0);
	OPP_INDEXED_LIST_CREATE2(&gcore.layers, 2, 0);
	return 0;
}

static int platform_window_deinit() {
	// TODO destroy all the windows
	opp_factory_destroy(&gcore.pwins);
	opp_factory_destroy(&gcore.layers);
	return 0;
}

