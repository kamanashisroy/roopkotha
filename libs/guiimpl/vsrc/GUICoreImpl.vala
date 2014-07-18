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
	internal ArrayList<Window>windows;
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
		aroop_uword32 cmd = bndlr.getIntContent();
		switch(cmd) {
		case Window.tasks.RESIZE:
		{
			// get the arguments ..
			int key = bndlr.next();
			core.assert(key == entries.ARG);
			aroop_uword32 wid = bndlr.getIntContent();
			key = bndlr.next();
			core.assert(key == entries.ARG);
			aroop_uword32 w = bndlr.getIntContent();
			key = bndlr.next();
			core.assert(key == entries.ARG);
			aroop_uword32 h = bndlr.getIntContent();
			Window?win = windows.get((int)wid);
			if(win != null)win.onResize((int)w,(int)h);
			break;
		}
		case Window.tasks.KEY_PRESS:
		{
			// get the arguments ..
			int key = bndlr.next();
			core.assert(key == entries.ARG);
			aroop_uword32 wid = bndlr.getIntContent();
			key = bndlr.next();
			core.assert(key == entries.ARG);
			aroop_uword32 keycode = bndlr.getIntContent();
			key = bndlr.next();
			core.assert(key == entries.ARG);
			aroop_uword32 shiftcode = bndlr.getIntContent();
			Window?win = windows.get((int)wid);
			if(win != null)win.onEvent(null, GUIInput.eventType.KEYBOARD_EVENT, (int)keycode, (int)shiftcode, 0);
			break;
		}
		}
		return 0;
	}

	public int performTasks() {
		do {
			extring task = extring();
			popTaskAs(&task);
			if(task.is_empty())
				break;

			Bundler bndlr = Bundler();
			bndlr.buildFromEXtring(&task);
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
				extring dlg = extring.stack(128);
				dlg.printf("Faulty task packet from platform");
				Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.ERROR, 0, 0, &dlg);
			}
		} while(true);
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
	public override void pushTask(extring*task) {
		plat.pushTask(task);
	}
	public override void popTaskAs(extring*task) {
		plat.popTaskAs(task);
	}
	public override void pushGraphicsTask(Graphics g) {
		GraphicsPixelMap gfx = (GraphicsPixelMap)(g);
		gfx.finalize();
		extring task = extring();
		gfx.task.getTaskAs(&task);
		Watchdog.logInt(core.sourceFileName(), core.sourceLineNo(), 10, "Graphics task size", task.length());
		if(task.length() > 0)
			plat.pushTask(&task);
	}
}
/** @} */
