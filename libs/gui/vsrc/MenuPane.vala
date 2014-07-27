using aroop;
using roopkotha.gui;

/** \addtogroup gui
 *  @{
 */
public class roopkotha.gui.MenuPane: Menu {
	public MenuPane() {
		base(new BasicFont(), new BasicFont());
		gfx = null;
	}
	GraphicsTask?gfx;
	public override roopkotha.gui.Graphics getGraphics() {
		if(gfx != null)
			return gfx;
		GUITask task = GUICoreModule.gcore.createTask(1024);
		gfx = new GraphicsTask.fromTask(task);
		return gfx;
	}

}
/** @} */
