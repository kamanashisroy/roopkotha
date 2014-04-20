using aroop;
using shotodol;
using roopkotha.platform;
using roopkotha.gui;

/** \addtogroup guiimpl
 *  @{
 */
public class roopkotha.gui.WindowImpl : roopkotha.gui.Window {
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
		Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), "WindowImpl:show\n");
		roopkotha.gui.GUICore.setDirty(this);
		plat.show();
	}
		
	public override void postPaint(roopkotha.gui.Graphics g) {
		GraphicsImpl gi = (g as GraphicsImpl);
		plat.paint_end(gi.plat);
	}

	public override roopkotha.gui.Font getFont(roopkotha.gui.Font.Face face, roopkotha.gui.Font.Variant vars) {
		// TODO use a font factory ..
		return new FontImpl();
	}
}
/** @} */
