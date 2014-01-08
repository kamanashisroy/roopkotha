using aroop;

namespace roopkotha {
	[CCode (cname="QTRoopkothaGraphics",has_copy_function=true, free_function="qt_impl_graphics_destroy", cheader_filename = "shotodol_linux_gui.h")]
	public class GraphicsPlatformImpl {
		[CCode (cname="qt_impl_graphics_create")]
		public static GraphicsPlatformImpl create();
		[CCode (cname="qt_impl_draw_image")]
		public void drawImage(onubodh.RawImage img, int x, int y, int anc);
		[CCode (cname="qt_impl_draw_line")]
		public void drawLine(int x1, int y1, int x2, int y2);
		[CCode (cname="qt_impl_draw_rect")]
		public void drawRect(int x, int y, int width, int height);
		[CCode (cname="qt_impl_draw_round_rect")]
		public void drawRoundRect(int x, int y, int width, int height, int arcWidth, int arcHeight);
		[CCode (cname="qt_impl_draw_string")]
		public void drawString(etxt*str, int x, int y, int width, int height, int anc);
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
	[CCode (cname="QTRoopkothaFont",has_copy_function=true, free_function="qt_impl_font_destroy", cheader_filename = "shotodol_linux_gui.h")]
	public class FontPlatformImpl {
		[CCode (cname="qt_impl_font_create")]
		public static FontPlatformImpl create();
		[CCode (cname="qt_impl_font_get_height")]
		public int getHeight();
		[CCode (cname="qt_impl_font_get_substring_width")]
		public int subStringWidth(etxt*str, int offset, int width);
	}
	[CCode (cname="qt_window_handle_event_t")]
	public delegate int WindowEventHandler(int flags, int key_code, int x, int y);
	[CCode (cname="QTRoopkothaWindow",has_copy_function=true, free_function="qt_impl_window_destroy", cheader_filename = "shotodol_linux_gui.h")]
	public class WindowPlatformImpl {
		[CCode (cname="qt_impl_window_create")]
		public static WindowPlatformImpl create();
		[CCode (cname="qt_impl_window_show")]
		public void show();
		[CCode (cname="qt_impl_window_paint_end")]
		public void paint_end(GraphicsPlatformImpl g);
		[CCode (cname="qt_impl_window_set_event_handler")]
		public int setEventHandler(WindowEventHandler eh);
	}
	
	[CCode (cname="QTRoopkothaGUICore",has_copy_function=true, free_function="qt_impl_guicore_destroy", cheader_filename = "shotodol_linux_gui.h")]
	public class GUICorePlatformImpl {
		[CCode (cname="qt_impl_guicore_create")]
		public static GUICorePlatformImpl create();
		[CCode (cname="qt_impl_guicore_step")]
		public int step();
	}
}


