using aroop;
using shotodol;
using roopkotha.platform;
using roopkotha.rtree;
using roopkotha.gui;

/** \addtogroup guiimpl
 *  @{
 */

public struct roopkotha.gui.GUIInputEvent {
	public int flags;
	public int key_code;
	public int x;
	public int y;
}
public class roopkotha.gui.GUIInputImpl : GUIInput {
	RTreeBranch? rtr;
	Window?win;
	~GUIInputImpl() {
		rtr = null;
		win = null;
	}
	public override int registerScreenEvent(EventOwner?target, int x, int y, int width, int height) {
		RTreeRect2DInt rect = RTreeRect2DInt.boundary(x,y,x+width,y+height); // XXX will it work from stack ? or do we need memory allocation ?
		rtr.insertRect(&rect, 0, target);
		extring dlg = extring.stack(128);
		dlg.printf("Adding rect:(%d,%d,%d,%d)\n", x, y, x+width, y+height);
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 100, Watchdog.Severity.DEBUG, 0, 0, &dlg);
		return 0;
	}
	public override int reset(roopkotha.gui.Window aWin) { /*< This should be called before registering action */
		rtr = null;
		rtr = new RTreeBranch();
		win = aWin;
		return 0;
	}

	GUIInputEvent evt;
	int onScreenEvent(Replicable target) {
		// Note: -1 to make up for the +1 when data was inserted
		//printf("Hit data rect %d\n", id-1);
		win.onEvent((EventOwner)target, evt.flags, evt.key_code, evt.x, evt.y);
		//return 1; // keep going
		return 0;
	}

	public int eventCallback(int flags, int key_code, int x, int y) {
		extring dlg = extring.stack(64);
		dlg.printf("keycode:%d, x:%d, y:%d", key_code, x, y);
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 100, Watchdog.Severity.DEBUG, 0, 0, &dlg);
		if(win == null) {
			//print("No window\n");
			return 0;
		}
		if((flags & GUIInput.eventType.SCREEN_EVENT) != 0) {
			evt = GUIInputEvent();
			evt.flags = flags;
			evt.key_code = key_code;
			evt.x = x;
			evt.y = y;
			RTreeRect2DInt r = RTreeRect2DInt.boundary(x,y,x+1,y+1);// XXX will it work from stack ? or do we need memory allocation ?
			//print("Finding point:(%d,%d)\n", x, y);
			rtr.search(&r, onScreenEvent);
		} else {
			win.onEvent(null, flags, key_code, x, y);
		}
		return 0;
	}
}

/** @} */
