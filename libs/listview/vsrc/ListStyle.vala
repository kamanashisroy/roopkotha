using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup listview
 *  @{
 */
public enum roopkotha.listview.ListStyleTarget {
	LIST_INDICATOR,
	LIST_BG,
}
public struct roopkotha.listview.ListStyle {

	int colormap[4];
	int flag;
	public ListStyle() {
		colormap[ListStyleTarget.LIST_INDICATOR] = 0x006699; // MENU_BORDER_HOVER
		colormap[ListStyleTarget.LIST_BG] = 0xFFFFFF; // MENU_BG
	}
	public int getColor(int styleName) {
		return colormap[styleName];
	}
	public bool testFlag(int fl) {
		return (flag & fl) != 0;
	}
}

