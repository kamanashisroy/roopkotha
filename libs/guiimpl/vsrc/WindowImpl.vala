using aroop;
using shotodol;
using roopkotha;

public class roopkotha.WindowImpl : roopkotha.Window {
	WindowPlatformImpl plat;
	GUIInputImpl giimpl;
	public WindowImpl(etxt*aTitle) {
		menu = new MenuImpl();
		TITLE_FONT = new FontImpl();
		base(aTitle);
		plat = WindowPlatformImpl.create();
		giimpl = new GUIInputImpl();
		giimpl.reset(this);
		gi = giimpl;
		plat.setEventHandler(giimpl.eventCallback);
	}
	
	~WindowImpl() {
	}
	
	public override void show() {
		Watchdog.logString("WindowImpl:show\n");
		roopkotha.GUICore.setDirty(this);
		plat.show();
	}
		
	public override void postPaint(roopkotha.Graphics g) {
		GraphicsImpl gi = (g as GraphicsImpl);
		plat.paint_end(gi.plat);
	}
}
