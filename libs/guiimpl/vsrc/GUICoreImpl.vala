using aroop;
using shotodol;
using roopkotha.platform;
using roopkotha.gui;

/** \addtogroup guiimpl
 *  @{
 */
public class roopkotha.gui.GUICoreImpl : roopkotha.gui.GUICore {
	GUICorePlatformImpl plat;
	public Factory<GUITask>taskFactory;
	public static GUICoreImpl?gcore;
	public GUICoreImpl() {
		print("Creating new platform application\n");
		plat = GUICorePlatformImpl.create();
		taskFactory = Factory<GUITask>.for_type(64);
		base();
		gcore = this;
		step();
	}
	
	~GUICoreImpl() {
		taskFactory.destroy();
	}
		
	public override int step() {
		plat.step();
		do {
			WindowImpl? win = (WindowImpl)painter.dequeue();
			if(win == null) {
				break;
			}
			// TODO get the panes ..
			Iterator<container<Pane>>it = Iterator<container<Pane>>.EMPTY();
			win.getPaneIterator(&it, Replica_flags.ALL, 0);
			while(it.next()) {
				Pane pn = it.get().get();
				Graphics g = pn.getGraphics();
				// TODO check if the pane has changed
				pn.paint(g);
				Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, "GUICore:step():paint");
				gcore.pushGraphicsTask(g);
			}
			it.destroy();
			//g.close();
		} while(true);
		plat.step();
		return 0;
	}

	public override int start(shotodol.Spindle?plr) { 
		print("GUICore stepping started..\n");
		return 0;
	}
	public override void pushTask(etxt*task) {
		plat.pushTask(task);
	}
	public override void popTaskAs(etxt*task) {
		plat.popTaskAs(task);
	}
	public override void pushGraphicsTask(Graphics g) {
		GraphicsPixelMap gfx = (GraphicsPixelMap)(g);
		gfx.finalize();
		etxt task = etxt.EMPTY();
		gfx.task.getTaskAs(&task);
		plat.pushTask(&task);
	}
}
/** @} */
