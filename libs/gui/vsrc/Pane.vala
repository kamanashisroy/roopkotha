using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup gui
 *  @{
 */
public abstract class roopkotha.gui.Pane : Hashable {
	protected bool dirty;
	public Pane() {
		dirty = false;
	}
	public bool isDirty() {
		return dirty;
	}
	public abstract int onResize(int w, int h);
	public abstract void paint(roopkotha.gui.Graphics g);
	public abstract roopkotha.gui.Graphics getGraphics();
}

/** @} */
