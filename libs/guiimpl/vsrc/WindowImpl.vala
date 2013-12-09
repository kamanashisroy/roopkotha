using aroop;
using shotodol;
using roopkotha;

public class roopkotha.WindowImpl : roopkotha.Window {
	WindowPlatformImpl plat;
	public WindowImpl() {
		base();
		plat = WindowPlatformImpl();
	}
	
	~WindowImpl() {
		plat.destroy();
	}
	
	public override void show() {
#if FIXME_LATER
		xultb_guicore_set_dirty(win);
		xultb_guicore_walk(0); // XXX should I force it to render ??
		//GUI_LOG("Showing Window ..[It should be called once ..]\n");
#endif
		plat.show();
	}
	
	public override void paint(roopkotha.Graphics g) {
		base.paint(g);
		plat.paint_end((g as GraphicsImpl).plat);
	}
}
