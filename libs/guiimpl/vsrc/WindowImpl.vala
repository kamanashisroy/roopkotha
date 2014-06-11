using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup guiimpl
 *  @{
 */

public class roopkotha.gui.WindowImpl : roopkotha.gui.Window {
	int windowId;
	GUITask?showTask;
	GUICore?gcore;
	ArrayList<Pane>panes;
	public WindowImpl(etxt*aTitle) {
		menu = new MenuImpl();
		TITLE_FONT = new FontImpl();
		gcore = null;
		gfx = null;
		panes = ArrayList<Pane>();
		base(aTitle);
		windowId = 0x01; // currently we support only one window.
		GUIInputImpl eHandler = new GUIInputImpl();
		eHandler.reset(this);
		gi = eHandler;
	}
	
	~WindowImpl() {
		panes.destroy();
	}
	
	public override void show() {
		if(showTask == null) {
			showTask = new GUITask();
			Bundler bndlr = Bundler();
			bndlr.setCarton(&showTask.msg, 32);
			bndlr.writeInt(GUICore.entries.WINDOW_TASK, tasks.SHOW_WINDOW);
			bndlr.writeInt(GUICore.entries.ARG, windowId);
			showTask.finalize(bndlr);
		}
		etxt task = etxt.EMPTY();
		showTask.getTaskAs(&task);
		gcore.pushTask(&task);
	}

	public override roopkotha.gui.Font getFont(roopkotha.gui.Font.Face face, roopkotha.gui.Font.Variant vars) {
		return new FontImpl.defined(face,vars);
	}

	GraphicsPixelMap?gfx;
	public override roopkotha.gui.Graphics getGraphics() {
		if(gfx != null)
			return gfx;
		GUITask task = new GUITask();
		gfx = new GraphicsPixelMap(&task.msg, 32);
		return gfx;
	}

	public override int setPane(int pos, Pane pn) {
		panes.set(pos, pn);
		return 0;
	}

	public void plugGUICore(GUICore gGUICore) {
		gcore = gGUICore;
	}

}
/** @} */
