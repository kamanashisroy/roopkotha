using aroop;
using shotodol;
using roopkotha.platform;
using roopkotha.gui;

/**
 * \ingroup gui
 * \defgroup guiimpl GUI Implementation.
 */
/** \addtogroup guiimpl
 *  @{
 */
public class roopkotha.gui.GUICoreImpl : roopkotha.gui.GUICore {
	GUICorePlatformImpl plat;
	internal ArrayList<Window>windows;
	public GUICoreImpl() {
		print("Creating new platform application\n");
		plat = GUICorePlatformImpl.create();
		windows = ArrayList<Window>();
		base();
	}
	
	~GUICoreImpl() {
	}

	public override GUIInput createInputHandler(Window win, int token) {
		GUIInputImpl x = new GUIInputImpl();
		x.reset(win);
		windows.set(token, win);
		return x;
	}

	public int performWindowTask(Unbundler*ubndlr) {
		aroop_uword32 cmd = ubndlr.getIntContent();
		switch(cmd) {
		case Window.tasks.RESIZE:
		{
			// get the arguments ..
			try {
			int key = ubndlr.next();
			core.assert(key == entries.ARG);
			aroop_uword32 wid = ubndlr.getIntContent();
			key = ubndlr.next();
			core.assert(key == entries.ARG);
			aroop_uword32 w = ubndlr.getIntContent();
			key = ubndlr.next();
			core.assert(key == entries.ARG);
			aroop_uword32 h = ubndlr.getIntContent();
			Window?win = windows.get((int)wid);
			if(win != null)win.onResize((int)w,(int)h);
			} catch(BundlerError excp) {}
			break;
		}
		case Window.tasks.KEY_PRESS:
		{
			// get the arguments ..
			try {
			int key = ubndlr.next();
			core.assert(key == entries.ARG);
			aroop_uword32 wid = ubndlr.getIntContent();
			key = ubndlr.next();
			core.assert(key == entries.ARG);
			aroop_uword32 keycode = ubndlr.getIntContent();
			key = ubndlr.next();
			core.assert(key == entries.ARG);
			aroop_uword32 shiftcode = ubndlr.getIntContent();
			Window?win = windows.get((int)wid);
			if(win != null)win.onEvent(null, GUIInput.eventType.KEYBOARD_EVENT, (int)keycode, (int)shiftcode, 0);
			} catch(BundlerError excp) {}
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

			Unbundler ubndlr = Unbundler();
			ubndlr.build(&task);
			int key = 0;
			try {
				while((key = ubndlr.next()) >= 0) {
					switch(key) {
						case entries.WINDOW_TASK:
							performWindowTask(&ubndlr);
						break;
					}
				}
			} catch(BundlerError e) {
				extring dlg = extring.stack(128);
				dlg.printf("Faulty task packet from platform");
				Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.Severity.ERROR, 0, 0, &dlg);
			}
		} while(true);
		return 0;
	}
	
	public override int step() {
		plat.step();
		performTasks();
		do {
			PanedWindow? win = (PanedWindow)painter.dequeue(); // XXX this is a bug in the design, we take Window as argument but we cast them to PanedWindow indiscriminately 
			if(win == null) {
				break;
			}
			win.process();
		} while(true);
		plat.step();
		return 0;
	}

	public override int start(shotodol.Fiber?plr) { 
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
		GraphicsTask gfx = (GraphicsTask)(g);
		gfx.finalize();
		extring task = extring();
		gfx.task.getContentAs(&task);
		Watchdog.logInt(core.sourceFileName(), core.sourceLineNo(), 10, "Graphics task size", task.length());
		if(task.length() > 0)
			plat.pushTask(&task);
	}
}
/** @} */
