using aroop;
using shotodol;
using roopkotha.platform;
using roopkotha.gui;

/** \addtogroup guiimpl
 *  @{
 */
public class roopkotha.gui.WindowImpl : roopkotha.gui.Window {
	int windowId;
	etxt showTask;
	public WindowImpl(etxt*aTitle) {
		menu = new MenuImpl();
		TITLE_FONT = new FontImpl();
		base(aTitle);
		windowId = 0x01; // currently we support only one window.
		GUIInputImpl eHandler = new GUIInputImpl();
		eHandler.reset(this);
		gi = eHandler;
		showTask = etxt.EMPTY();
	}
	
	~WindowImpl() {
	}
	
	public override void show() {
		if(showTask.is_empty()) {
			showTask.buffer(34);
			Carton c = showTask;
			Bundler bdlr = Bundler(c, 34);
			bndlr.writeInt(GUICore.entries.GRAPHICS_TASK, tasks.SHOW_WINDOW);
			bndlr.writeInt(GUICore.entries.ARG, windowId);
			bdlr.close();
		}
		gcore.pushTask(&showTask);
	}

	public override roopkotha.gui.Font getFont(roopkotha.gui.Font.Face face, roopkotha.gui.Font.Variant vars) {
		return new FontImpl.defined(face,vars);
	}
}
/** @} */
