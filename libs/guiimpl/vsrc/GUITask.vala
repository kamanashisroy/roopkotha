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
	public void build() {
		len = 0;
		size = 32;
	}
	public void finalize(Bundler bndlr) {
		bndlr.close();
		len = bndlr.size;
	}
	public void getTaskAs(etxt*task) {
		*task = etxt.given_length((string)msg.data, len, this);
	}
}

/** @} */

