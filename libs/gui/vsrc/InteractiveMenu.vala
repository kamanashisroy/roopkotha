using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup gui
 *  @{
 */
public class roopkotha.gui.InteractiveMenu: Menu {
	public InteractiveMenu(Style*style, GUIInput input, extring*givenPath) {
		base(style, input, givenPath);
	}

	public override void onResize(int t, int l, int w, int h, int padding) {
		dirty = true;
		width = w;
		height = h;
	}

	public bool handleEvent(roopkotha.gui.Window win, EventOwner?target, int flags, int key_code, int x, int y) {
		if(handleEventHelper(win, target, flags, key_code, x, y)) {
			dirty = true;
			return true;
		}
		return false;
	}
	public bool handleEventHelper(roopkotha.gui.Window win, EventOwner?target, int flags, int key_code, int x, int y) {
		if((flags & roopkotha.gui.GUIInput.eventType.KEYBOARD_EVENT) != 0) {
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "keyboard : ..\n");
			switch(x) {
			case roopkotha.gui.GUIInput.keyEventType.KEY_UP:
				if(active) {
					if(((selected - 1) >= 0))selected--;
					return true;
				} else {
					Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Menu is closed\n");
					return false;
				}
				break;
			case roopkotha.gui.GUIInput.keyEventType.KEY_DOWN:
				if(active) {
					if(!((selected + 1) >= menuOptions.count_unsafe()))selected++;
					return true;
				} else {
					Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Menu is closed\n");
					return false;
				}
				break;
			case roopkotha.gui.GUIInput.keyEventType.KEY_F1:
				Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Menu left pressed\n");
	//			left = 1;
				if(active) {
					target = CANCEL;
				} else {
					target = MENU;
				}
				break;
			case roopkotha.gui.GUIInput.keyEventType.KEY_F2:
				Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Menu right pressed\n");
				target = rightOption;
				break;
			case roopkotha.gui.GUIInput.keyEventType.KEY_ENTER:
			case roopkotha.gui.GUIInput.keyEventType.KEY_RETURN:
				Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Menu selected\n");
				if(menuOptions != null && active) {
					EventOwner cmd = menuOptions.get(selected);
					if(cmd != null) {
						target = cmd;
					}
				} else {
					Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Menu is closed\n");
					return false;
				}
				break;
			case roopkotha.gui.GUIInput.keyEventType.KEY_ESCAPE:
				active = false;
				return true;
			default:
				Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "This is not traversing key\n");
				return false;
			}
		}

		if(target == null) {
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "No target\n");
			return false;
		}


		int i;
		bool right = false, left = false;

		Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Menu Clicked\n");
		EventOwner? firstOption = null;

		if(target.is_same(rightOption)) {
			right = true;
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Right menu\n");
		} else if(active) {
			if(target.is_same(CANCEL)) {
				left = true;
				Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Close menu\n");
			} else if(menuOptions != null)for (i=0;i<menuOptions.count_unsafe() && i >= 0;i++) {
				EventOwner cmd = menuOptions.get(i);
				if(cmd == target) {
					left = true;
					i = -2; // break
					extring dlg = extring.stack(128);
					extring label = extring();
					cmd.getLabelAs(&label);
					dlg.printf("Left menu:%s", label.to_string());
					Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dlg);
				}
				if(i == 0) {
					firstOption = cmd;
				}
			}
		} else if(target == MENU){
			left = true;
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Open menu\n");
		}
		if(!right && !left) {
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Not a menu event\n");
			return false;
		}

	//				if(length == selected) {
	//					selectedOption = menuOptions[i];
	//				}
		if (right) {
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Window action\n");
			win.onAction(rightOption);
			active = false;
		} else if (active) {
			if(target.is_same(CANCEL as Replicable)) {
				active = false;
			} else {
				win.onAction(target);
				active = false;
			}
		} else {
			/* check if the "Options" or "Exit" buttons were pressed */
			if(menuOptions == null) {
				/* This is not menu action */
				return false;
			}
			if(menuOptions.count_unsafe() == 1) {
				/* this is direct action */
				win.onAction(firstOption);
			} else {
				selected = 0;
				active = true;
			}
		}
		return true; /* menu action has done something, so the action is digested */
	}


}
/** @} */
