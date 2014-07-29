using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.listview;

/** \addtogroup listview
 *  @{
 */
public class roopkotha.listview.ListPane : roopkotha.gui.Pane {
 
	roopkotha.gui.Font item_font;
	bool continuous_scrolling;

	int vpos; /* Index of the showing Item */

	int leftMargin;
	int topMargin;
	int rightMargin;
	int bottomMargin;
	int RESOLUTION;
	int left;
	int top;
	int width;
	int height;

	public enum display {
		HMARGIN = 3,
		VMARGIN = 2,
		RESOLUTION = 8,
	}

	ListContentModel content;
	ListStyle style;
	GraphicsTask?gfx;
	
	public ListPane(ListContentModel givenContent) {
		vpos = 0;
		continuous_scrolling = true;
		item_font = new BasicFont();
		content = givenContent;
		style = ListStyle();
		gfx = null;
	}

	public override void onResize(int l, int t, int w, int h) {
		left = l;
		top = t;
		width = w;
		height = h;
	}
	
	public void setDirty() {
		dirty = true;
	}

	int showItem(roopkotha.gui.Graphics g, Replicable data, int y, bool selected) {
		roopkotha.listview.ListViewItem? li = null;
#if false
		if(obj instanceof ListItem) {
		  li = (ListItem)obj;
		} else {
		  li = content.getListItem(obj);
		}
#else
		//print("Showing list item 1\n");
		li = content.getListItem(data);
#endif
		if(li == null)
		  return 0;
		li.focused = selected;
		int ret = li.paint(this, g, this.leftMargin + ListPane.display.HMARGIN
				, y + ListPane.display.VMARGIN
				, width - ListPane.display.HMARGIN - ListPane.display.HMARGIN - 1 - this.leftMargin - this.rightMargin
				, selected) + ListPane.display.VMARGIN + ListPane.display.VMARGIN;
		li = null;
		return ret;
	}

	void showItems(roopkotha.gui.Graphics g) {
		int i = -1;
		aroop.ArrayList<Replicable>*items = content.getItems();
		int posY = this.panelTop + this.topMargin;

		extring dlg = extring.stack(64);
		dlg.printf("Iterating items\n");
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dlg);
		// sanity check
		if (items == null) {
			return;
		}
		// clear
		g.setColor(style.getColor(ListStyleTarget.LIST_BG));
		g.fillRect(this.leftMargin, this.panelTop, width, this.menuY - this.panelTop);

		g.setFont(this.item_font);

		if (content.selectedIndex > items.count_unsafe()) {
			content.selectedIndex = 0;
		}
		dlg.printf("Iterating items(%d)\n", this.vpos);
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dlg);
		for (i = this.vpos;;i++) {
			//print("Showing list item :%d\n", i);
			Replicable? obj = items.get(i);
			if(obj == null) {
				//print("Showing list item :%d:Object is NULL\n", i);
				break;
			}
			/* see if selected index is more than the item count */
			dlg.printf("Showing item\n");
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dlg);
			posY += this.showItem(g, obj, posY, i == content.selectedIndex);
			if (posY > (this.menuY - this.bottomMargin)) {
				if (content.selectedIndex >= i && this.vpos < content.selectedIndex) {
					this.vpos++;
					/* try to draw again */
					this.showItems(g);
				}
				/* no more place to draw */

				// So there are more elements left ..
				// draw an arrow
				g.setColor(style.getColor(ListStyleTarget.LIST_INDICATOR));
				int x = width - 3 * ListPane.display.HMARGIN - ListPane.display.RESOLUTION - this.rightMargin;
				int y = this.menuY - this.bottomMargin - this.PADDING - 2 * ListPane.display.RESOLUTION;
				g.fillTriangle(x + ListPane.display.RESOLUTION / 2, y + ListPane.display.RESOLUTION, x + ListPane.display.RESOLUTION,
						y, x, y);
				dlg.printf("No more place to draw\n");
				Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dlg);
				break;
			}
		}
	}

	public override void paint(roopkotha.gui.Graphics g) {
		extring dlg = extring.stack(64);
		dlg.printf("Drawing list...\n");
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dlg);
		/* Draw the ListView Items */
		this.showItems(g);
		if (this.vpos > 0) {
			// So there are elements that can be scrolled back ..
			// draw an arrow
			g.setColor(style.getColor(ListStyleTarget.LIST_INDICATOR));
			int x = width - 3 * ListPane.display.HMARGIN - ListPane.display.RESOLUTION - this.rightMargin;
			int y = this.panelTop + this.topMargin + this.PADDING + ListPane.display.RESOLUTION;
			g.fillTriangle(x + ListPane.display.RESOLUTION / 2, y, x + ListPane.display.RESOLUTION, y + ListPane.display.RESOLUTION,
					x, y + ListPane.display.RESOLUTION);
		}
		aroop.xtring hint = content.getHint();
		if (hint != null && !menu.isActive() && content.selectedIndex != -1 && content.getCount()
				!= 0) {
			g.setColor(style.getColor(ListStyleTarget.LIST_BG));
			g.setFont(menu.getBaseFont());
			g.drawString(hint
					, 0
					, 0
					, width
					, height - roopkotha.gui.Menu.display.PADDING
					, roopkotha.gui.Graphics.anchor.HCENTER|roopkotha.gui.Graphics.anchor.BOTTOM);
			/* TODO show "<>"(90 degree rotated) icon to indicate that we can traverse through the list  */
		}
		Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, "All done");
	}

	public override roopkotha.gui.Graphics getGraphics() {
		if(gfx != null)
			return gfx;
		GUITask task = GUICoreModule.gcore.createTask(1024);
		gfx = new GraphicsTask.fromTask(task);
		return gfx;
	}
}
/** @} */
