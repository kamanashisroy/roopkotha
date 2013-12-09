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

public abstract class roopkotha.ListView : roopkotha.Window {
 
        roopkotha.Font item_font;
        bool continuous_scrolling;

        int vpos; /* Index of the showing Item */
        int selected_index;

        int leftMargin;
        int topMargin;
        int rightMargin;
        int bottomMargin;
        int RESOLUTION;

        aroop.txt default_command;
				//ActionListener lis;
        aroop.ArrayList<Replicable>? _items;

	public enum display {
		HMARGIN = 3,
		VMARGIN = 2,
		RESOLUTION = 8,
	}

	public void set_action_listener(ActionListener lis) {
		if(lis != null)this.lis = lis;
	}

  public aroop.ArrayList<Replicable>*get_items() {
		return &this._items;
	}

  public virtual roopkotha.ListViewItem getListItem(Replicable data) {
		return (roopkotha.ListViewItem)data;
	}

 	public abstract int get_count();
	public aroop.txt? get_hint() {
		return null;
	}

	public Replicable? get_selected() {
		ArrayList<Replicable>*items = this.get_items();
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

	public abstract int get_selected_index();
	public virtual bool handle_item(Replicable?target, int flags, int key_code, int x, int y) {
		return false;
	}
	
	private int show_item(roopkotha.Graphics g, Replicable data, int y, bool selected) {
		roopkotha.ListViewItem? li = null;
#if false
		if(obj instanceof ListItem) {
		  li = (ListItem)obj;
		} else {
		  li = getListItem(obj);
		}
#else
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

	private void show_items(roopkotha.Graphics g) {
		int i = -1;
		aroop.ArrayList<Replicable>*items = this.get_items();
		void*obj;
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
#if FIXME_LATER
		for (i = this.vpos;;i++) {
			int break_here = 0;
			opp_at_ncode(obj, items, i,
				/* see if selected index is more than the item count */
				dlg.printf("Showing item\n");
				Watchdog.logMsgDoNotUse(&dlg);
				posY += this.show_item(g, obj, posY, i == this.selected_index);
				if (posY > (this.menuY - this.bottomMargin)) {
					if (this.selected_index >= i && this.vpos < this.selected_index) {
						this.vpos++;
						/* try to draw again */
						this.show_items(g);
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
					break_here = 1;
				}
			) else {
				break;
			}
			if(break_here) {
				break;
			}
		}
#endif
	}

	private void native_paint(roopkotha.Graphics g) {
		etxt dlg = etxt.stack(64);
		dlg.printf("Drawing list...\n");
		Watchdog.logMsgDoNotUse(&dlg);
		/* Draw the ListView Items */
		this.show_items(g);
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

		base.paint(g);
		aroop.txt hint = this.get_hint();
		if (hint != null && !roopkotha.Menu.is_active() && this.selected_index != -1 && this.get_count()
				!= 0) {
			// #ifndef net.ayaslive.miniim.ui.core.list.draw_menu_at_last
			// #expand g.setColor(%net.ayaslive.miniim.ui.core.list.bg%);
			g.setColor(0xFFFFFF);
			g.setFont(roopkotha.Menu.get_base_font());
			// #endif
			g.drawString(hint
					, 0
					, 0
					, this.width
					, this.height - roopkotha.Menu.display.PADDING
					, roopkotha.Graphics.anchor.HCENTER|roopkotha.Graphics.anchor.BOTTOM);
			/* TODO show "<>"(90 degree rotated) icon to indicate that we can traverse through the list  */
		}
	}

	public override void paint(roopkotha.Graphics g) {
		roopkotha.ListView list = (roopkotha.ListView)this;
		this.native_paint(g);
	}


	public override bool handle_event(Replicable target, int flags, int key_code, int x, int y) {
		roopkotha.ListView list = (roopkotha.ListView )this;
		roopkotha.ActionInput.log("handling menu command\n");
		if(base.handle_event(target, flags, key_code, x, y)) {
			return true;
		}

		roopkotha.ActionInput.log("Handle menu commands2\n");
		// dispatch selected element events
		if(this.handle_item(target, flags, key_code, x, y)) {
			return true;
		}
		roopkotha.ActionInput.log("So the target is list item\n");
		if((flags & roopkotha.ActionInput.event.SCREEN_EVENT) != 0) {
			ArrayList<Replicable>*items = list.get_items();
			int i;
#if FIXME_LATER
			for(i=0;items && i>=0;i++) {
				void*obj;
				opp_at_ncode(obj, items, i,
					if(obj == target) {
						roopkotha.ActionInput.log("let us make it selected: %d\n", i);
						this.selected_index = i;
						roopkotha.GUICore.set_dirty(this); // may be we should refresh partial
						i = -2;
					}
				) else {
					break;
				}
			}
#endif
		} else {
			int consumed = 0;
			roopkotha.ActionInput.log("Try to edit with keycode:%d, selected index:%d\n", key_code, this.selected_index);
			// if it is keyboard event then perform keyboard tasks
			Replicable? obj = list.get_selected();
			if(obj != null) {
				roopkotha.ListViewItem? item = list.getListItem(obj);
				if(item != null) {
					consumed = item.DoEdit(flags, key_code, x, y);
				}
			}
			if(consumed != 0) {
				roopkotha.GUICore.set_dirty(this); // TODO tell it to refresh only a portion ..
				return true;
			}
			key_code = (x != 0)?x:key_code; // handle arrow keys ..
		}
		/* else traverse the list items and work for menu */
		if (key_code == roopkotha.ActionInput.key_event.KEY_UP) {
			this.selected_index--;
			if (this.selected_index < 0) {
				if (this.continuous_scrolling) {
					this.selected_index = list.get_count() - 1;
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
			roopkotha.GUICore.set_dirty2(this, roopkotha.ListView.display.HMARGIN, this.panelTop
					, this.width - roopkotha.ListView.display.HMARGIN - roopkotha.ListView.display.HMARGIN, this.menuY);
		} else if (key_code == roopkotha.ActionInput.key_event.KEY_DOWN) {
			this.selected_index++;
			int count = list.get_count();
			if (count != -1 && this.selected_index >= count) {
				if (this.continuous_scrolling) {
					this.selected_index = 0;
				} else {
					this.selected_index = count - 1;
				}
			}
			/*----------------------------------------------- repaint only the list and menu */
			roopkotha.GUICore.set_dirty2(this, roopkotha.ListView.display.HMARGIN
					, this.panelTop, this.width - roopkotha.ListView.display.HMARGIN - roopkotha.ListView.display.HMARGIN, this.menuY);
		} else if (key_code == roopkotha.ActionInput.key_event.KEY_ENTER) {
			if(this.lis != null) {
				this.lis.perform_action(this.default_command/*target*/); // should not it be target !
				/*----------------------------------------------- repaint only the list and menu */
				roopkotha.GUICore.set_dirty2(this, roopkotha.ListView.display.HMARGIN
						, this.panelTop, this.width - roopkotha.ListView.display.HMARGIN - roopkotha.ListView.display.HMARGIN, this.menuY);
			}
		}
		return true;
	}
}

#if 0
static struct roopkotha.ListViewItem* xultb_list_get_list_item(struct xultb_list*list, void*data) {
	return NULL;
}
#endif


#if 0
static struct opp_vtable_xultb_window vtable_xultb_window_list;

OPP_CB(xultb_list) {
	struct xultb_list*list = (struct xultb_list*)data;
	switch(callback) {
	case OPPN_ACTION_INITIALIZE:
		memset(list, 0, sizeof(struct xultb_list));
		Watchdog.logMsgDoNotUse("Creating list ..\n");
		{
			va_list apa;
			if(opp_super_cb(xultb_window)(&this.super_data, OPPN_ACTION_INITIALIZE, NULL, apa, 0)) {
				va_end(apa);
				return -1;
			}
			va_end(apa);
		}
		this.super_data.vtable = &vtable_xultb_window_list;
		opp_vtable_set(list, xultb_list);
		opp_indexed_list_create2(&this._items, 4);
		this.vpos = 0;
		this.continuous_scrolling = true;
		this.item_font = roopkotha.Font_create();
		if(cb_data) {
			Watchdog.logMsgDoNotUse("Setting title ..\n");
			aroop.txt*title = cb_data;
			if(title)this.super_data.title = title;
			aroop.txt*default_command = va_arg(ap, aroop.txt*);
			if(default_command)this.default_command = OPPREF(default_command);
		}
		Watchdog.logMsgDoNotUse("Created xultb_list\n");
		return 0;
	case OPPN_ACTION_FINALIZE:
#if FIXME_LATER
		OPPUNREF(this.default_command);
#endif
		opp_factory_destroy(&this._items);
		{
			va_list ap;
			if(vtable_xultb_window.oppcb(&this.super_data, OPPN_ACTION_FINALIZE, NULL, ap, 0)) {
				return -1;
			}
		}
		break;
	}
	return 0;
}

static struct opp_factory xultb_list_factory;
struct xultb_list*xultb_list_create(aroop.txt*title, aroop.txt*default_command) {
	return opp_alloc4(&xultb_list_factory, 0, 0, title, default_command);
}

int xultb_list_system_init() {
	vtable_xultb_window_list = vtable_xultb_window;
	vtable_xultb_window_list.paint = xultb_list_window_paint_wrapper;
	vtable_xultb_window_list.handle_event = xultb_list_window_handle_event_wrapper;
	SYNC_ASSERT(OPP_FACTORY_CREATE(
			&xultb_list_factory
			, 1,sizeof(xultb_list)
			, OPP_CB_FUNC(xultb_list)) == 0);
	return 0;
}
#endif
