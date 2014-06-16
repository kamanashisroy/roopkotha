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
	public ArrayList<Window>windows;
	public static GUICoreImpl?gcore;
	public GUICoreImpl() {
		print("Creating new platform application\n");
		plat = GUICorePlatformImpl.create();
		taskFactory = Factory<GUITask>.for_type(64);
		windows = ArrayList<Window>();
		base();
		gcore = this;
		//step();
	}
	
	~GUICoreImpl() {
		taskFactory.destroy();
	}

	public int performWindowTask(Bundler*bndlr) {
		int cmd = bndlr.getIntContent();
		switch(cmd) {
		case Window.tasks.RESIZE:
		{
			// get the arguments ..
			int key = bndlr.next();
			core.assert(key == entries.ARG);
			int wid = bndlr.getIntContent();
			key = bndlr.next();
			core.assert(key == entries.ARG);
			int w = bndlr.getIntContent();
			key = bndlr.next();
			core.assert(key == entries.ARG);
			int h = bndlr.getIntContent();
			Window win = windows.get(wid);
			win.onResize(w,h);
			break;
		}
		}
		return 0;
	}

	public int performTasks() {
		etxt task = etxt.stack(512);
		popTaskAs(&task);
		if(task.is_empty())
			return 0;

		Bundler bndlr = Bundler();
		int key = 0;
		try {
			while((key = bndlr.next()) >= 0) {
				switch(key) {
					case entries.WINDOW_TASK:
						performWindowTask(&bndlr);
					break;
				}
			}
		} catch(BundlerError e) {
			etxt dlg = etxt.stack(128);
			dlg.printf("Faulty task packet from platform");
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.ERROR, 0, 0, &dlg);
		}
		return 0;
	}
	
	public override int step() {
		plat.step();
		performTasks();
		do {
			WindowImpl? win = (WindowImpl)painter.dequeue();
			if(win == null) {
				break;
			}
			win.process();
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
		Watchdog.logInt(core.sourceFileName(), core.sourceLineNo(), 10, "Graphics task size", task.length());
		if(task.length() > 0)
			plat.pushTask(&task);
	}
}
/** @} */
