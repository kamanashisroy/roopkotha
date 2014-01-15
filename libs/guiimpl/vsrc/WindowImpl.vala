using aroop;
using shotodol;
using roopkotha;

public class roopkotha.WindowImpl : roopkotha.Window {
	WindowPlatformImpl plat;
	public WindowImpl(etxt*aTitle) {
		menu = new MenuImpl();
		TITLE_FONT = new FontImpl();
		base(aTitle);
		plat = WindowPlatformImpl.create();
		GUIInputImpl eHandler = new GUIInputImpl();
		eHandler.reset(this);
		gi = eHandler;
		plat.setEventHandler(eHandler.eventCallback);
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

	public override roopkotha.Font getFont(roopkotha.Font.Face face, roopkotha.Font.Variant vars) {
		// TODO use a font factory ..
		return new FontImpl();
	}
}
