using aroop;
using shotodol;
using roopkotha;

public class roopkotha.WindowImpl : roopkotha.Window {
	WindowPlatformImpl plat;
	public WindowImpl(etxt*aTitle) {
		base(aTitle);
		plat = WindowPlatformImpl.create();
	}
	
	~WindowImpl() {
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
		GraphicsImpl gi = (g as GraphicsImpl);
		plat.paint_end(gi.plat);
	}
}
