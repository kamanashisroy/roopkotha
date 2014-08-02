using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.doc;
using roopkotha.veladivml;
using roopkotha.vela;

/** \addtogroup velapp
 *  @{
 */
/**
 * You can only trust the numbers. 
 * [-Maturity- 10]
 */
internal class roopkotha.velapad.VelaPad : VelaPadMenu {
	public VelaPad() {
		base();
	}
	public int loadFile(extring*fn) {
		Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "VelaPadCommand:Open file ...\n");
		try {
			FileInputStream fistm = new FileInputStream.from_file(fn);
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "VelaPadCommand:Open file: Opened file for reading ...\n");

			VelaDivDocument doc = new VelaDivDocument();
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "VelaPadCommand:Open file: Reading ...\n");

			doc.setInputStream(fistm);
			doc.tryReading();
			fistm.close();
			extring entry = extring.set_static_string("vela/onContentDisplay");
			Plugin.swarm(&entry, &entry, null);
			show(doc);

			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "VelaPadCommand:Open file: Done.\n");
		} catch(IOStreamError.FileInputStreamError e) {
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "VelaPadCommand:Open file: Could not open file\n");
			return -1;
		}
		return 0;
	}
}
/** @} */
