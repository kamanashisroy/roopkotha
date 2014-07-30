/*
 * This file part of MiniIM.
 *
 * Copyright (C) 2007  Kamanashis Roy
 *
 * MiniIM is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * MiniIM is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with MiniIM.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup listview
 *  @{
 */
public abstract class roopkotha.gui.listview.ListView : roopkotha.gui.PanedWindow {
 
	EventOwner? defaultCommand;
	ListPane lpane;
	protected ListContentModel content;
	
	public ListView(extring*aTitle, extring*aPath, extring*aDefaultCommand, ListContentModel model) {
		base(aTitle,aPath);
		defaultCommand = new EventOwner(this, aDefaultCommand);
		lpane = new ListPane(model, gi);
		content = model;
		Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.LOG, 0, 0, "Created ListView");
	}
	
	public Replicable? getSelected() {
		ArrayList<Replicable>*items = content.getItems();
		if(items == null) {
			return null;
		}
		//return items[this.selectedIndex];
		return items.get(content.selectedIndex);
	}

	public virtual bool onItemEvent(Replicable?target, int flags, int key_code, int x, int y) {
		return false;
	}
	
	public override bool onEvent(EventOwner?target, int flags, int key_code, int x, int y) {
		extring dlg = extring.stack(128);
		dlg.printf("Handling menu command for keycode %d\n and x %d ", key_code, x);
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dlg);
		if(base.onEvent(target, flags, key_code, x, y)) {
			return true;
		}

		Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, "Main menu has nothing to do here");
		// dispatch selected element events
		if(this.onItemEvent(target, flags, key_code, x, y)) {
			return true;
		}
		Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, "The event is on the selected item");
		if((flags & roopkotha.gui.GUIInput.eventType.SCREEN_EVENT) != 0) {
			ArrayList<Replicable>*items = content.getItems();
			int i;
			if(items != null)for(i=0;;i++) {
				Replicable?obj = items.get(i);
				if(obj == target) {
					dlg.printf("let us make it selected: %d\n", i);
					Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dlg);
					content.selectedIndex = i;
					lpane.setDirty(); // TODO menu.setDirty();
					roopkotha.gui.GUICoreModule.gcore.setDirty(this); // may be we should refresh partial
					i = -2;
				}
			}
		} else {
			bool consumed = false;
			dlg.printf("Try to edit with keycode:%d, selected index:%d\n", key_code, content.selectedIndex);
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dlg);
			// if it is keyboard event then perform keyboard tasks
			Replicable? obj = getSelected();
			if(obj != null) {
				ListViewItem? item = content.getListItem(obj);
				if(item != null) {
					consumed = item.doEdit(flags, key_code, x, y);
				}
			}
			if(consumed) {
				roopkotha.gui.GUICoreModule.gcore.setDirty(this); // TODO tell it to refresh only a portion ..
				return true;
			}
			key_code = (x != 0)?x:key_code; // handle arrow keys ..
		}
		/* else traverse the list items and work for menu */
		if (key_code == roopkotha.gui.GUIInput.keyEventType.KEY_UP) {
			lpane.scroll(true);
			/*----------------------------------------------- repaint only the list and menu */
			lpane.setDirty(); // TODO menu.setDirty();
			roopkotha.gui.GUICoreModule.gcore.setDirty(this);
		} else if (key_code == roopkotha.gui.GUIInput.keyEventType.KEY_DOWN) {
			lpane.scroll(false);
			/*----------------------------------------------- repaint only the list and menu */
			lpane.setDirty(); // TODO menu.setDirty();
			roopkotha.gui.GUICoreModule.gcore.setDirty(this);
		} else if (key_code == roopkotha.gui.GUIInput.keyEventType.KEY_ENTER) {
			onAction(defaultCommand/*target*/); // should not it be target !
#if false
			/*----------------------------------------------- repaint only the list and menu */
			lpane.setDirty(); // TODO menu.setDirty();
			roopkotha.gui.GUICoreModule.gcore.setDirty(this);
#endif
		}
		return true;
	}

	// TODO register this hook extension in gui/window/menu/hint
	int hintHook(extring*pagePath, extring*hint) {
		if(content.selectedIndex != -1 && content.getCount() != 0) {
			content.getHintAs(hint);
		}
		return 0;
	}
}
/** @} */
