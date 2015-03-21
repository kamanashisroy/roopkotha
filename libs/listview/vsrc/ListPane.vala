using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.gui.listview;

/** \addtogroup listview
 *  @{
 */
public class roopkotha.gui.listview.ListPane : roopkotha.gui.Pane {
 
	roopkotha.gui.Font item_font;
	bool continuous_scrolling;

	int vpos; /* Index of the showing Item */

	int left;
	int top;
	int width;
	int height;
	int PADDING;

	public enum display {
		HMARGIN = 3,
		VMARGIN = 2,
		RESOLUTION = 8,
	}

	ListContentModel content;
	ListStyle style;
	GraphicsTask?gfx;
	GUIInput input;
	
	public ListPane(ListContentModel givenContent, GUIInput givenInput) {
		vpos = 0;
		continuous_scrolling = true;
		item_font = new BasicFont();
		content = givenContent;
		style = ListStyle();
		gfx = null;
		PADDING = 0;
		input = givenInput;
	}

	public override void onResize(int l, int t, int w, int h, int gPadding) {
		left = l;
		top = t;
		width = w;
		height = h;
		PADDING = gPadding;
		dirty = true;
	}
	
	public void setDirty() {
		dirty = true;
	}

	public void scroll(bool up) {
		if(up) {
			content.selectedIndex--;
			if (content.selectedIndex < 0) {
				if (continuous_scrolling) {
					content.selectedIndex = content.getCount() - 1;
				} else {
					content.selectedIndex = 0; /* stay within limits */
				}
			}
			if (vpos > content.selectedIndex) {
				vpos--;
#if false
				mark(this.vpos);
#endif
			}
		} else {
			content.selectedIndex++;
			int count = content.getCount();
			if (count != -1 && content.selectedIndex >= count) {
				if (this.continuous_scrolling) {
					content.selectedIndex = 0;
				} else {
					content.selectedIndex = count - 1;
				}
			}
		}
	}

	int showItem(roopkotha.gui.Graphics g, Replicable data, int y, bool selected) {
		ListViewItem? li = null;
#if false
		if(obj instanceof ListViewItem) {
		  li = (ListViewItem)obj;
		} else {
		  li = content.getListViewItem(obj);
		}
#else
		//print("Showing list item 1\n");
		li = content.getListViewItem(data);
#endif
		if(li == null)
		  return 0;
		li.focused = selected;
		int ret = li.paint(input, g, left + ListPane.display.HMARGIN
				, y + ListPane.display.VMARGIN
				, width - ListPane.display.HMARGIN - ListPane.display.HMARGIN - 1 - left - ListPane.display.HMARGIN
				, selected) + ListPane.display.VMARGIN + ListPane.display.VMARGIN;
		li = null;
		return ret;
	}

	void showItems(roopkotha.gui.Graphics g) {
		int i = -1;
		aroop.ArrayList<Replicable>*items = content.getItems();
		int posY = top + display.HMARGIN;

		extring dlg = extring.stack(64);
		dlg.printf("Iterating items\n");
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.Severity.DEBUG, 0, 0, &dlg);
		// sanity check
		if (items == null) {
			return;
		}
		// clear
		g.setColor(style.getColor(ListStyleTarget.LIST_BG));
		g.fillRect(left, top, width, height);

		g.setFont(this.item_font);

		if (content.selectedIndex > items.count_unsafe()) {
			content.selectedIndex = 0;
		}
		dlg.printf("Iterating items(%d)\n", this.vpos);
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.Severity.DEBUG, 0, 0, &dlg);
		for (i = this.vpos;;i++) {
			//print("Showing list item :%d\n", i);
			Replicable? obj = items.get(i);
			if(obj == null) {
				//print("Showing list item :%d:Object is NULL\n", i);
				break;
			}
			/* see if selected index is more than the item count */
			dlg.printf("Showing item\n");
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.Severity.DEBUG, 0, 0, &dlg);
			posY += this.showItem(g, obj, posY, i == content.selectedIndex);
			if (posY > (top + height - display.VMARGIN)) {
				if (content.selectedIndex >= i && this.vpos < content.selectedIndex) {
					this.vpos++;
					/* try to draw again */
					this.showItems(g);
				}
				/* no more place to draw */

				// So there are more elements left ..
				// draw an arrow
				g.setColor(style.getColor(ListStyleTarget.LIST_INDICATOR));
				int x = width - 3 * ListPane.display.HMARGIN - ListPane.display.RESOLUTION - ListPane.display.HMARGIN;
				int y = top + height - display.VMARGIN - this.PADDING - 2 * ListPane.display.RESOLUTION;
				g.fillTriangle(x + ListPane.display.RESOLUTION / 2, y + ListPane.display.RESOLUTION, x + ListPane.display.RESOLUTION,
						y, x, y);
				dlg.printf("No more place to draw\n");
				Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.Severity.DEBUG, 0, 0, &dlg);
				break;
			}
		}
	}

	public override void paint(roopkotha.gui.Graphics g) {
		extring dlg = extring.stack(64);
		dlg.printf("Drawing list...\n");
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.Severity.DEBUG, 0, 0, &dlg);
		/* Draw the ListView Items */
		this.showItems(g);
		if (this.vpos > 0) {
			// So there are elements that can be scrolled back ..
			// draw an arrow
			g.setColor(style.getColor(ListStyleTarget.LIST_INDICATOR));
			int x = width - 3 * ListPane.display.HMARGIN - ListPane.display.RESOLUTION - ListPane.display.HMARGIN;
			int y = top + display.VMARGIN + this.PADDING + ListPane.display.RESOLUTION;
			g.fillTriangle(x + ListPane.display.RESOLUTION / 2, y, x + ListPane.display.RESOLUTION, y + ListPane.display.RESOLUTION,
					x, y + ListPane.display.RESOLUTION);
		}
		Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.Severity.DEBUG, 0, 0, "All done");
		dirty = false;
	}

	public override roopkotha.gui.Graphics getGraphics() {
		if(gfx != null && !gfx.isUsed())
			return gfx;
		Bag task = GUICoreModule.bagBuilder.createBag(1024);
		gfx = new GraphicsTask.fromTask(task);
		return gfx;
	}
}
/** @} */
