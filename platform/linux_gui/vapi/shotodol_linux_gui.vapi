using aroop;

namespace roopkotha {
	[CCode (cname="class QTRoopkothaGraphics", cheader_filename = "shotodol_linux_gui.h")]
	public struct GraphicsPlatformImpl {
		[CCode (cname="qt_impl_graphics_create")]
		public GraphicsPlatformImpl();
		[CCode (cname="qt_impl_graphics_destroy")]
		public void destroy();
		[CCode (cname="qt_impl_draw_image")]
		public void drawImage(onubodh.RawImage img, int x, int y, int anc);
		[CCode (cname="qt_impl_draw_line")]
		public void drawLine(int x1, int y1, int x2, int y2);
		[CCode (cname="qt_impl_draw_rect")]
		public void drawRect(int x, int y, int width, int height);
		[CCode (cname="qt_impl_draw_round_rect")]
		public void drawRoundRect(int x, int y, int width, int height, int arcWidth, int arcHeight);
		[CCode (cname="qt_impl_draw_string")]
		public void drawString(aroop.txt str, int x, int y, int width, int height, int anc);
		[CCode (cname="qt_impl_fill_rect")]
		public void fillRect(int x, int y, int width, int height);
		[CCode (cname="qt_impl_fill_round_rect")]
		public void fillRoundRect(int x, int y, int width, int height, int arcWidth, int arcHeight);
		[CCode (cname="qt_impl_fill_triangle")]
		public void fillTriangle(int x1, int y1, int x2, int y2, int x3, int y3);
		[CCode (cname="qt_impl_get_color")]
		public int getColor();
		[CCode (cname="qt_impl_set_color")]
		public void setColor(int rgb);
		[CCode (cname="qt_impl_set_font")]
		public void setFont(FontPlatformImpl font);
		[CCode (cname="qt_impl_start")]
		public void start();
	}
	[CCode (cname="class QTRoopkothaFont", cheader_filename = "shotodol_linux_gui.h")]
	public struct FontPlatformImpl {
		[CCode (cname="qt_impl_font_create")]
		public FontPlatformImpl();
		[CCode (cname="qt_impl_font_destroy")]
		public void destroy();
		[CCode (cname="qt_impl_font_get_height")]
		public int getHeight();
		[CCode (cname="qt_impl_font_get_substring_width")]
		public int subStringWidth(aroop.txt str, int offset, int width);
	}
	
	[CCode (cname="class QTRoopkothaWindow", cheader_filename = "shotodol_linux_gui.h")]
	public struct WindowPlatformImpl {
		[CCode (cname="qt_impl_window_create")]
		public WindowPlatformImpl();
		[CCode (cname="qt_impl_window_destroy")]
		public void destroy();
		[CCode (cname="qt_impl_window_show")]
		public void show();
		[CCode (cname="qt_impl_window_paint_end")]
		public void paint_end(GraphicsPlatformImpl g);
	}
	
	[CCode (cname="void", cheader_filename = "shotodol_linux_gui.h")]
	public struct GUICorePlatformImpl {
		[CCode (cname="aroop_do_nothing")]
		public GUICorePlatformImpl();
		[CCode (cname="aroop_do_nothing")]
		public void destroy();
		[CCode (cname="qt_impl_guicore_step")]
		public int step();
		[CCode (cname="qt_impl_guicore_init")]
		public int cmain(int*argc, string argv[]);
	}
}


