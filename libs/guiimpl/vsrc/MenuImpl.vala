using aroop;
using roopkotha.platform;
using roopkotha.gui;

/** \addtogroup guiimpl
 *  @{
 */
public class roopkotha.gui.MenuImpl: Menu {
	public MenuImpl() {
		base(new FontImpl(), new FontImpl());
		gfx = null;
	}
	GraphicsPixelMap?gfx;
	public override roopkotha.gui.Graphics getGraphics() {
		if(gfx != null)
			return gfx;
		GUITask task = new GUITask();
		gfx = new GraphicsPixelMap(&task.msg, 32);
		return gfx;
	}

}
/** @} */
