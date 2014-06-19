using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup gui
 *  @{
 */
public enum roopkotha.gui.StyleTarget {
	MENU_BG,
	MENU_BG_HOVER,
	MENU_BORDER_HOVER,
	MENU_FG,
	MENU_FG_HOVER,
	MENU_BG_BASE,
	MENU_FG_BASE,
	MENU_BASE_SHADOW,
	MENU_TOWER_BORDER,
}
public enum roopkotha.gui.StyleApproach {
	LIGHT = 1,
}
public struct roopkotha.gui.Style {

	int colormap[16];
	int flag;
	public Style() {
		colormap[StyleTarget.MENU_BG] = 0xFFFFFF;
		colormap[StyleTarget.MENU_BG_HOVER] = 0x0099CC;
		colormap[StyleTarget.MENU_BORDER_HOVER] = 0x006699;
		colormap[StyleTarget.MENU_FG] = 0x000000;
		colormap[StyleTarget.MENU_FG_HOVER] = 0xFFFFFF;
		colormap[StyleTarget.MENU_BG_BASE] = 0x006699;
		colormap[StyleTarget.MENU_FG_BASE] = 0xFFFFFF;
		colormap[StyleTarget.MENU_BASE_SHADOW] = 0x006699;
		colormap[StyleTarget.MENU_TOWER_BORDER] = 0xCCCCCC; // gray
	}
	public int getColor(int styleName) {
		return colormap[styleName];
	}
	public bool testFlag(int fl) {
		return (flag & fl) != 0;
	}
}

