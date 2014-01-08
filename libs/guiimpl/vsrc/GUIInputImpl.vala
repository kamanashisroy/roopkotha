using aroop;
using shotodol;
using roopkotha;

public struct roopkotha.GUIInputEvent {
	public int flags;
	public int key_code;
	public int x;
	public int y;
}
public class roopkotha.GUIInputImpl : GUIInput {
	RTreeBranch? rtr;
	Window?win;
	~GUIInputImpl() {
		rtr = null;
		win = null;
	}
	public override int registerScreenEvent(Replicable?target, int x, int y, int width, int height) {
		RTreeRect2DInt rect = RTreeRect2DInt.boundary(x,y,x+width,y+height); // XXX will it work from stack ? or do we need memory allocation ?
		rtr.insertRect(&rect, 0, target);
		print("Adding rect:(%d,%d,%d,%d)\n", x, y, x+width, y+height);
		return 0;
	}
	public override int reset(roopkotha.Window aWin) { /*< This should be called before registering action */
		rtr = null;
		rtr = new RTreeBranch();
		win = aWin;
		return 0;
	}

	GUIInputEvent evt;
	int onScreenEvent(Replicable?target) {
		// Note: -1 to make up for the +1 when data was inserted
		//printf("Hit data rect %d\n", id-1);
		win.handle_event(target, evt.flags, evt.key_code, evt.x, evt.y);
		//return 1; // keep going
		return 0;
	}

	public int eventCallback(int flags, int key_code, int x, int y) {
	//	GUI_INPUT_LOG( "See what we can do ..\n");
		if(win == null) {
			print("No window\n");
			return 0;
		}
		if((flags & GUIInput.eventType.SCREEN_EVENT) != 0) {
			evt = GUIInputEvent();
			evt.flags = flags;
			evt.key_code = key_code;
			evt.x = x;
			evt.y = y;
			RTreeRect2DInt r = RTreeRect2DInt.boundary(x,y,x+1,y+1);// XXX will it work from stack ? or do we need memory allocation ?
			print("Finding point:(%d,%d)\n", x, y);
			rtr.search(&r, onScreenEvent);
		} else {
			win.handle_event(null, flags, key_code, x, y);
		}
		return 0;
	}
}

