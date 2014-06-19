int perform_window_task(aroop_txt_t*msg, int*offset, int*cur_key, int*cur_type, int*cur_len) {
	// check the task ..
	static int ready = 0;
	ready++;
	int cmd = msg_numeric_value(msg, offset, cur_type, cur_len);
	SYNC_ASSERT(msg_next(msg, offset, cur_key, cur_type, cur_len) != -1);
	SYNC_ASSERT(*cur_key == ENUM_ROOPKOTHA_GUI_CORE_TASK_ARG);
	int wid = msg_numeric_value(msg, offset, cur_type, cur_len);
	Window pw = (Window)opp_indexed_list_get(&gcore.pwins, wid);
	GC gc = (GC)opp_indexed_list_get(&gcore.pgfx, wid);
	switch(cmd) {
	case ENUM_ROOPKOTHA_GUI_WINDOW_TASK_SHOW_WINDOW:
		if(pw == 0) {
			unsigned long mybackground = WhitePixel (gcore.disp, gcore.scrn);
 			unsigned long myforeground = BlackPixel (gcore.disp, gcore.scrn);
			//unsigned long mybackground = BlackPixel (gcore.disp, gcore.scrn);
 			//unsigned long myforeground = WhitePixel (gcore.disp, gcore.scrn);
  			XSizeHints myhint;
			/* Suggest where to position the window: */
			myhint.x = 200;
			myhint.y = 200;
			myhint.width = 300;
			myhint.height = 300;
			myhint.flags = PPosition | PSize;

			pw = XCreateSimpleWindow(gcore.disp, DefaultRootWindow(gcore.disp), myhint.x, myhint.y, myhint.width, myhint.height, 5, myforeground, mybackground);
			aroop_indexed_list_set(&gcore.pwins, wid, pw);
  			XSetStandardProperties (gcore.disp, pw, default_title, default_title, None, argv, argc, &myhint);
			if(gc == NULL) {
				gc = XCreateGC(gcore.disp, pw, 0, 0);
				aroop_indexed_list_set(&gcore.pgfx, wid, gc);
				XSetBackground (gcore.disp, gc, mybackground);
				XSetForeground (gcore.disp, gc, myforeground);	/* Select input devices to listen to: */
				XSelectInput (gcore.disp, pw, StructureNotifyMask | ButtonPressMask | KeyPressMask | ExposureMask);	/* Actually display the window: */
				// display window
				XMapRaised (gcore.disp, pw);
				//XMapWindow(gcore.disp, pw);
				watchdog_log_string("Created new X11 window\n");
  				//XEvent myevent;XNextEvent (gcore.disp, &myevent); // this will render the window in effect
			}
		}
		watchdog_log_string("Show window\n");
		break;
	case ENUM_ROOPKOTHA_GUI_WINDOW_TASK_DESTROY:
		aroop_indexed_list_set(&gcore.pgfx, wid, NULL);
		if(gc != NULL) {
			// TODO destroy graphics
		}
		aroop_indexed_list_set(&gcore.pwins, wid, NULL);
		if(pw != NULL) {
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
	return 0;
}

static int platform_window_init() {
	OPP_INDEXED_LIST_CREATE2(&gcore.pwins, 2, OPPL_POINTER_NOREF);
	OPP_INDEXED_LIST_CREATE2(&gcore.pgfx, 2, OPPL_POINTER_NOREF);
	OPP_INDEXED_LIST_CREATE2(&gcore.layers, 2, 0);
	return 0;
}

static int platform_window_deinit() {
	// TODO destroy all the windows
	opp_factory_destroy(&gcore.pwins);
	opp_factory_destroy(&gcore.pgfx);
	opp_factory_destroy(&gcore.layers);
	return 0;
}


