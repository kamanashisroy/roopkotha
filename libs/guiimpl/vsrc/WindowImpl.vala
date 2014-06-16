using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup guiimpl
 *  @{
 */

public class roopkotha.gui.WindowImpl : roopkotha.gui.Window {
	internal int windowId;
	ArrayList<Pane>panes;
	GraphicsPixelMap?gfx;
	TitleImpl titlePane;
	protected int panelTop;
	bool dirty;
	public WindowImpl(etxt*aTitle) {
		menu = new MenuImpl();
		gfx = null;
		panes = ArrayList<Pane>();
		windowId = 0x01; // currently we support only one window.
		titlePane = new TitleImpl(this, aTitle, PADDING);
		base();
		setPane(19, titlePane);
		GUIInputImpl eHandler = new GUIInputImpl();
		eHandler.reset(this);
		gi = eHandler;
		panelTop = 0;
		dirty = false;
	}
	
	~WindowImpl() {
		panes.destroy();
	}
	
	public override int onResize(int w, int h) {
		base.onResize(w, h);
		titlePane.onResize(w, h);
		setDirty();
		return 0;
	}

	public override void setTitle(aroop.txt title) {
		titlePane.setTitle(title);
	}

	public void setDirty() {
		if(dirty) {
			return;
		}
		GUICoreImpl.gcore.setDirty(this);
		dirty = true;
	}

	public override void show() {
		GUITask showTask = GUICoreImpl.gcore.taskFactory.alloc_full(32);
		showTask.build(32);
		Bundler bndlr = Bundler();
		bndlr.setCarton(&showTask.msg, 32);
		bndlr.writeInt(GUICore.entries.WINDOW_TASK, tasks.SHOW_WINDOW);
		bndlr.writeInt(GUICore.entries.ARG, windowId);
		showTask.finalize(&bndlr);
		etxt task = etxt.EMPTY();
		showTask.getTaskAs(&task);
		GUICoreImpl.gcore.pushTask(&task);
		setDirty();
	}

	public override roopkotha.gui.Font getFont(roopkotha.gui.Font.Face face, roopkotha.gui.Font.Variant vars) {
		return new FontImpl.defined(face,vars);
	}

#if false
	public override roopkotha.gui.Graphics getGraphics() {
		if(gfx != null)
			return gfx;
		GUITask task = GUICoreImpl.gcore.taskFactory.alloc_full(512);
		task.build(512);
		gfx = new GraphicsPixelMap.fromTask(task);
		return gfx;
	}
#endif

	public override int setPane(int pos, Pane pn) {
		panes.set(pos, pn);
		return 0;
	}

	public void getPaneIterator(Iterator<container<Pane>>*it, int if_set, int if_not_set) {
		panes.iterator_hacked(it, if_set, if_not_set, 0);
	}

	public int process() {
		dirty = false;
		Iterator<container<Pane>>it = Iterator<container<Pane>>.EMPTY();
		getPaneIterator(&it, Replica_flags.ALL, 0);
		while(it.next()) {
			Pane pn = it.get().get();
			Graphics g = pn.getGraphics();
			// TODO check if the pane has changed
			if(pn.isDirty()) {
				pn.paint(g);
			}
			Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, "GUICore:step():paint");
			GUICoreImpl.gcore.pushGraphicsTask(g);
		}
		it.destroy();
		return 0;
	}
}
/** @} */
