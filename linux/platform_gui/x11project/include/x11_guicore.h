#ifndef X_GUICORE_H
#define X_GUICORE_H

#include "shotodol_platform_gui.h"

typedef struct {
	int width;
	int height;
	char *title;
	//Display*disp;
	int screen;
	Window root;
	Window w;
	GC gc;
	//XFontStruct * font;
	unsigned long black_pixel;    
	unsigned long white_pixel;
} x11_window_t;
static int platform_window_init();
static int platform_window_deinit();
static x11_window_t*create_window(Display*disp, Window root, int wid);
static x11_window_t*get_window(int wid);

#endif // X_GUICORE_H
