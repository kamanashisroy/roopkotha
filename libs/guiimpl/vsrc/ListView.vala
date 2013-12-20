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
using roopkotha;

public abstract class roopkotha.ListView : roopkotha.WindowImpl {
 
	roopkotha.Font item_font;
	bool continuous_scrolling;

	int vpos; /* Index of the showing Item */
	int selected_index;

	int leftMargin;
	int topMargin;
	int rightMargin;
	int bottomMargin;
	int RESOLUTION;

	aroop.txt defaultCommand;
			//ActionListener lis;
	public enum display {
		HMARGIN = 3,
		VMARGIN = 2,
		RESOLUTION = 8,
	}
	
	public ListView(etxt*aTitle, etxt*aDefault_command) {
		base(aTitle);
		defaultCommand = new txt.memcopy_etxt(aDefault_command);
		vpos = 0;
		continuous_scrolling = true;
		item_font = new FontImpl();
		etxt dlg = etxt.from_static("Created ListView\n");
		Watchdog.logMsgDoNotUse(&dlg);
	}
	
	~ListView() {
	}

	public void setActionListener(ActionListener aLis) {
		if(aLis != null)this.lis = aLis;
	}

	protected abstract aroop.ArrayList<Replicable>*getItems();
	protected abstract roopkotha.ListViewItem getListItem(Replicable data);

 	protected virtual int getCount() {
		return getItems().count_unsafe();
	}
	
	public aroop.txt? get_hint() {
		return null;
	}

	public Replicable? getSelected() {
		ArrayList<Replicable>*items = this.getItems();
		if(items == null) {
			return null;
		}
		//return items[this.selected_index];
		return items.get(this.selected_index);
	}

	public void set_selected_index(int index) {
		this.selected_index = index;
		return;
	}

	public virtual int getSelected_index() {
		return selected_index;
	}
	
	public virtual bool handle_item(Replicable?target, int flags, int key_code, int x, int y) {
		return false;
	}
	
	private int showItem(roopkotha.Graphics g, Replicable data, int y, bool selected) {
		roopkotha.ListViewItem? li = null;
#if false
		if(obj instanceof ListItem) {
		  li = (ListItem)obj;
		} else {
		  li = getListItem(obj);
		}
#else
		print("Showing list item 1\n");
		li = this.getListItem(data);
#endif
		if(li == null)
		  return 0;
		li.focused = selected;
		int ret = li.paint(g, this.leftMargin + roopkotha.ListView.display.HMARGIN
				, y + roopkotha.ListView.display.VMARGIN
				, this.width - roopkotha.ListView.display.HMARGIN - roopkotha.ListView.display.HMARGIN - 1 - this.leftMargin - this.rightMargin
				, selected) + roopkotha.ListView.display.VMARGIN + roopkotha.ListView.display.VMARGIN;
		li = null;
		return ret;
	}

	private void showItems(roopkotha.Graphics g) {
		int i = -1;
		aroop.ArrayList<Replicable>*items = this.getItems();
		int posY = this.panelTop + this.topMargin;

		etxt dlg = etxt.stack(64);
		dlg.printf("Iterating items\n");
		Watchdog.logMsgDoNotUse(&dlg);
		// sanity check
		if (items == null) {
			return;
		}
		// clear
		// #expand g.setColor(%net.ayaslive.miniim.ui.core.list.bg%);
		g.setColor(0xFFFFFF);
		g.fillRect(this.leftMargin, this.panelTop, this.width, this.menuY - this.panelTop);

		g.setFont(this.item_font);

		if (this.selected_index > items.count_unsafe()) {
			this.selected_index = 0;
		}
		dlg.printf("Iterating items(%d)\n", this.vpos);
		Watchdog.logMsgDoNotUse(&dlg);
		for (i = this.vpos;;i++) {
			print("Showing list item :%d\n", i);
			Replicable? obj = items.get(i);
			if(obj == null) {
				print("Showing list item :%d:Object is NULL\n", i);
				break;
			}
			/* see if selected index is more than the item count */
			dlg.printf("Showing item\n");
			Watchdog.logMsgDoNotUse(&dlg);
			posY += this.showItem(g, obj, posY, i == this.selected_index);
			if (posY > (this.menuY - this.bottomMargin)) {
				if (this.selected_index >= i && this.vpos < this.selected_index) {
					this.vpos++;
					/* try to draw again */
					this.showItems(g);
				}
				/* no more place to draw */

				// So there are more elements left ..
				// draw an arrow
				// #expand g.setColor(%net.ayaslive.miniim.ui.core.list.indicator%);
				g.setColor(0x006699);
				int x = this.width - 3 * roopkotha.ListView.display.HMARGIN - roopkotha.ListView.display.RESOLUTION - this.rightMargin;
				int y = this.menuY - this.bottomMargin - this.PADDING - 2 * roopkotha.ListView.display.RESOLUTION;
				g.fillTriangle(x + roopkotha.ListView.display.RESOLUTION / 2, y + roopkotha.ListView.display.RESOLUTION, x + roopkotha.ListView.display.RESOLUTION,
						y, x, y);
				dlg.printf("No more place to draw\n");
				Watchdog.logMsgDoNotUse(&dlg);
				break;
			}
		}
	}

	public override void paint(roopkotha.Graphics g) {
		etxt dlg = etxt.stack(64);
		dlg.printf("Drawing list...\n");
		Watchdog.logMsgDoNotUse(&dlg);
		/* Draw the ListView Items */
		this.showItems(g);
		if (this.vpos > 0) {
			// So there are elements that can be scrolled back ..
			// draw an arrow
			// #expand g.setColor(%net.ayaslive.miniim.ui.core.list.indicator%);
			g.setColor(0x006699);
			int x = this.width - 3 * roopkotha.ListView.display.HMARGIN - roopkotha.ListView.display.RESOLUTION - this.rightMargin;
			int y = this.panelTop + this.topMargin + this.PADDING + roopkotha.ListView.display.RESOLUTION;
			g.fillTriangle(x + roopkotha.ListView.display.RESOLUTION / 2, y, x + roopkotha.ListView.display.RESOLUTION, y + roopkotha.ListView.display.RESOLUTION,
					x, y + roopkotha.ListView.display.RESOLUTION);
		}
#if FIXME_LATER
		base.paint(g);
#endif
		aroop.txt hint = this.get_hint();
		if (hint != null && !menu.isActive() && this.selected_index != -1 && this.getCount()
				!= 0) {
			// #ifndef net.ayaslive.miniim.ui.core.list.draw_menu_at_last
			// #expand g.setColor(%net.ayaslive.miniim.ui.core.list.bg%);
			g.setColor(0xFFFFFF);
			g.setFont(menu.getBaseFont());
			// #endif
			g.drawString(hint
					, 0
					, 0
					, this.width
					, this.height - roopkotha.Menu.display.PADDING
					, roopkotha.Graphics.anchor.HCENTER|roopkotha.Graphics.anchor.BOTTOM);
			/* TODO show "<>"(90 degree rotated) icon to indicate that we can traverse through the list  */
		}
		dlg.printf("All done...\n");
		Watchdog.logMsgDoNotUse(&dlg);
	}

	public override bool handle_event(Replicable target, int flags, int key_code, int x, int y) {
		roopkotha.ListView list = (roopkotha.ListView )this;
		etxt dlg = etxt.stack(128);
		dlg.printf("handling menu command\n");
		Watchdog.logMsgDoNotUse(&dlg);
		if(base.handle_event(target, flags, key_code, x, y)) {
			return true;
		}

		dlg.printf("Handle menu commands2\n");
		Watchdog.logMsgDoNotUse(&dlg);
		// dispatch selected element events
		if(this.handle_item(target, flags, key_code, x, y)) {
			return true;
		}
		dlg.printf("So the target is list item\n");
		Watchdog.logMsgDoNotUse(&dlg);
		if((flags & roopkotha.GUIInput.eventType.SCREEN_EVENT) != 0) {
			ArrayList<Replicable>*items = list.getItems();
			int i;
			if(items != null)for(i=0;;i++) {
				Replicable?obj = items.get(i);
				if(obj == target) {
					dlg.printf("let us make it selected: %d\n", i);
					Watchdog.logMsgDoNotUse(&dlg);
					this.selected_index = i;
					roopkotha.GUICore.setDirty(this); // may be we should refresh partial
					i = -2;
				}
			}
		} else {
			bool consumed = false;
			dlg.printf("Try to edit with keycode:%d, selected index:%d\n", key_code, this.selected_index);
			Watchdog.logMsgDoNotUse(&dlg);
			// if it is keyboard event then perform keyboard tasks
			Replicable? obj = list.getSelected();
			if(obj != null) {
				roopkotha.ListViewItem? item = list.getListItem(obj);
				if(item != null) {
					consumed = item.doEdit(flags, key_code, x, y);
				}
			}
			if(consumed) {
				roopkotha.GUICore.setDirty(this); // TODO tell it to refresh only a portion ..
				return true;
			}
			key_code = (x != 0)?x:key_code; // handle arrow keys ..
		}
		/* else traverse the list items and work for menu */
		if (key_code == roopkotha.GUIInput.keyEventType.KEY_UP) {
			this.selected_index--;
			if (this.selected_index < 0) {
				if (this.continuous_scrolling) {
					this.selected_index = list.getCount() - 1;
				} else {
					this.selected_index = 0; /* stay within limits */
				}
			}
			if (this.vpos > this.selected_index) {
				this.vpos--;
#if false
				mark(this.vpos);
#endif
			}
			/*----------------------------------------------- repaint only the list and menu */
			roopkotha.GUICore.setDirtyFull(this, roopkotha.ListView.display.HMARGIN, this.panelTop
					, this.width - roopkotha.ListView.display.HMARGIN - roopkotha.ListView.display.HMARGIN, this.menuY);
		} else if (key_code == roopkotha.GUIInput.keyEventType.KEY_DOWN) {
			this.selected_index++;
			int count = list.getCount();
			if (count != -1 && this.selected_index >= count) {
				if (this.continuous_scrolling) {
					this.selected_index = 0;
				} else {
					this.selected_index = count - 1;
				}
			}
			/*----------------------------------------------- repaint only the list and menu */
			roopkotha.GUICore.setDirtyFull(this, roopkotha.ListView.display.HMARGIN
					, this.panelTop, this.width - roopkotha.ListView.display.HMARGIN - roopkotha.ListView.display.HMARGIN, this.menuY);
		} else if (key_code == roopkotha.GUIInput.keyEventType.KEY_ENTER) {
			if(this.lis != null) {
				this.lis.perform_action(this.defaultCommand/*target*/); // should not it be target !
				/*----------------------------------------------- repaint only the list and menu */
				roopkotha.GUICore.setDirtyFull(this, roopkotha.ListView.display.HMARGIN
						, this.panelTop, this.width - roopkotha.ListView.display.HMARGIN - roopkotha.ListView.display.HMARGIN, this.menuY);
			}
		}
		return true;
	}
}
