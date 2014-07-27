using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup guiimpl
 *  @{
 */

public class roopkotha.gui.GUITask : Replicable {
	public int size;
	public int len;
	public Carton msg;
	public void build(int gsize) {
		len = 0;
		// TODO get size automatically, not from parameter ..
		size = gsize;
	}
	public void finalize(Bundler*bndlr) {
		bndlr.close();
		len = bndlr.size;
	}
	public void getTaskAs(extring*task) {
		task.rebuild_and_set_content((string)msg.data, len, this);
	}
}

/** @} */

