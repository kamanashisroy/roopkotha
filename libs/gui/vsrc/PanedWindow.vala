using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup gui
 *  @{
 */

public class roopkotha.gui.PanedWindow : roopkotha.gui.Window {
	ArrayList<Pane>panes;
	TitlePane titlePane;
	protected int panelTop;
	bool dirty;
	public PanedWindow(extring*aTitle) {
		gi = GUICoreModule.gcore.createInputHandler(this);
		panes = ArrayList<Pane>();
		titlePane = new TitlePane(this, aTitle, PADDING);
		base(new MenuPane(this));
		setPane(19, titlePane);
		panelTop = 0;
		dirty = false;
	}
	
	~PanedWindow() {
		panes.destroy();
	}
	
	public override int onResize(int w, int h) {
		base.onResize(w, h);
		titlePane.onResize(w, h);
		setDirty();
		return 0;
	}

	public override void setTitle(aroop.xtring title) {
		titlePane.setTitle(title);
	}

	public void setDirty() {
		if(dirty) {
			return;
		}
		GUICoreModule.gcore.setDirty(this);
		dirty = true;
	}

	public override void show() {
		GUITask showTask = GUICoreModule.gcore.createTask(32);
		Bundler bndlr = Bundler();
		bndlr.buildFromCarton(&showTask.msg, 32);
		bndlr.writeInt(GUICore.entries.WINDOW_TASK, tasks.SHOW_WINDOW);
		bndlr.writeInt(GUICore.entries.ARG, get_token());
		showTask.finalize(&bndlr);
		extring task = extring();
		showTask.getTaskAs(&task);
		GUICoreModule.gcore.pushTask(&task);
		setDirty();
	}

	public override roopkotha.gui.Font getFont(roopkotha.gui.Font.Face face, roopkotha.gui.Font.Variant vars) {
		return new BasicFont.defined(face,vars);
	}

#if false
	public override roopkotha.gui.Graphics getGraphics() {
		if(gfx != null)
			return gfx;
		GUITask task = GUICoreModule.gcore.taskFactory.alloc_full(512);
		task.build(512);
		gfx = new GraphicsTask.fromTask(task);
		return gfx;
	}
#endif

	public override int setPane(int pos, Pane pn) {
		panes.set(pos, pn);
		return 0;
	}

	public void getPaneIterator(Iterator<AroopPointer<Pane>>*it, int if_set, int if_not_set) {
		panes.iterator_hacked(it, if_set, if_not_set, 0);
	}

	public int process() {
		dirty = false;
		Iterator<AroopPointer<Pane>>it = Iterator<AroopPointer<Pane>>.EMPTY();
		getPaneIterator(&it, Replica_flags.ALL, 0);
		while(it.next()) {
			Pane pn = it.get().get();
			Graphics g = pn.getGraphics();
			if(pn.isDirty()) {
				pn.paint(g);
			}
			Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, "GUICore:step():paint");
			GUICoreModule.gcore.pushGraphicsTask(g);
		}
		it.destroy();
		return 0;
	}
}
/** @} */
