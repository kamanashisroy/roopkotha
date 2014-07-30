using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup gui
 *  @{
 */

public class roopkotha.gui.PanedWindow : roopkotha.gui.Window {
	ArrayList<Pane>panes;
	TitlePane titlePane;
	bool dirty;
	int PADDING;
	enum layerFlags {
		CONTENT_FLAG = 1<<1,
	}
	public PanedWindow(extring*aTitle, extring*path) {
		gi = GUICoreModule.gcore.createInputHandler(this);
		panes = ArrayList<Pane>();
		titlePane = new TitlePane(this, aTitle);
		base(path);
		setPane(Window.layer.TITLE_BAR, titlePane);
		dirty = false;
		PADDING = 3;
	}
	
	~PanedWindow() {
		panes.destroy();
	}
	
	public override int onResize(int w, int h) {
		base.onResize(w, h);
		menu.onResize(0,0,w,h,PADDING);
		titlePane.onResize(0, 0, w, h, PADDING);
		Iterator<AroopPointer<Pane>>it = Iterator<AroopPointer<Pane>>.EMPTY();
		getPaneIterator(&it, layerFlags.CONTENT_FLAG, 0);
		int contentTop = titlePane.getVerticalSpanBottom();
		int contentBottom = menu.getVerticalSpanTop();
		while(it.next()) {
			unowned AroopPointer<Pane> ptr = it.get_unowned();
			unowned Pane pn = ptr.get();
			pn.onResize( 0, contentTop, w, h - contentTop - contentBottom, PADDING);
		}
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
		if(pos >= Window.layer.CONTENT_BAR && pos <= (Window.layer.CONTENT_BAR + 10)) {
			// TODO in the aroop documentation, describe this hack
			panes.addPointer(pn, pos, layerFlags.CONTENT_FLAG);
		} else
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
			unowned AroopPointer<Pane> ptr = it.get_unowned();
			unowned Pane pn = ptr.get();
			Graphics g = pn.getGraphics();
			if(pn.isDirty()) {
				g.start(this, (int)ptr.get_hash());
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
