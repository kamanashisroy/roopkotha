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
	public PanedWindow(extring*aTitle, extring*path) {
		dirty = false;
		panes = ArrayList<Pane>();
		titlePane = new TitlePane(aTitle);
		base(path);
		setPane(Window.layer.TITLE_BAR, titlePane);
		PADDING = 3;
	}
	
	~PanedWindow() {
		panes.destroy();
	}
	
	public override int onResize(int w, int h) {
		base.onResize(w, h);
		menu.onResize(0,0,w,h,PADDING);
		titlePane.onResize(0, 0, w, h, PADDING);
		int contentTop = titlePane.getVerticalSpanBottom();
		int contentBottom = menu.getVerticalSpanTop();
		Iterator<AroopPointer<Pane>>it = Iterator<AroopPointer<Pane>>.EMPTY();
		getPaneIterator(&it, Replica_flags.ALL, 0);
		while(it.next()) {
			unowned AroopPointer<Pane> ptr = it.get_unowned();
			int layer = (int)ptr.get_hash();
			if(layer < Window.layer.CONTENT_PANE) {
				continue;
			}
			unowned Pane pn = ptr.getUnowned();
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 3, "resize content()\n");
			pn.onResize( 0, contentTop, w, h - contentTop - contentBottom, PADDING);
		}
		setDirty();
		return 0;
	}

	public override void setTitle(aroop.xtring title) {
		titlePane.setTitle(title);
		setDirty();
	}

	public void setDirty() {
		if(dirty) {
			return;
		}
		GUICoreModule.gcore.setDirty(this);
		dirty = true;
	}

	public override void show() {
		Renu showTask = GUICoreModule.renuBuilder.createRenu(32);
		Bundler bndlr = Bundler();
		bndlr.buildFromCarton(&showTask.msg, 32);
		bndlr.writeInt(GUICore.entries.WINDOW_TASK, tasks.SHOW_WINDOW);
		bndlr.writeInt(GUICore.entries.ARG, getWindowToken());
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
			unowned AroopPointer<Pane> ptr = it.get_unowned();
			unowned Pane pn = ptr.getUnowned();
			if(pn.isDirty()) {
				Graphics g = pn.getGraphics();
				g.start(this, (int)ptr.get_hash());
				pn.paint(g);
				GUICoreModule.gcore.pushGraphicsTask(g);
				Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, "GUICore:step():paint");
			}
		}
		it.destroy();
		return 0;
	}
}
/** @} */
