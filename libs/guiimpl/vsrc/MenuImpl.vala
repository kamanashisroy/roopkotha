using aroop;
using roopkotha;

public class roopkotha.MenuImpl: Menu {
	public MenuImpl() {
		TOWER_FONT = new FontImpl(); // Font.getFont(Font.FACE_SYSTEM, Font.STYLE_PLAIN, Font.SIZE_SMALL);
		BASE_FONT = new FontImpl(); // Font.getFont(Font.FACE_SYSTEM, Font.STYLE_BOLD, Font.SIZE_SMALL);
		base();
	}
}
