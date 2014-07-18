using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.doc;

/** \addtogroup padapp
 *  @{
 */
public class roopkotha.app.WritePad : WritePadMenu {
	public WritePad() {
		base();
	}
	public int loadFile(extring*fn) {
		Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "WritePadCommand:Open file ...\n");
		try {
			FileInputStream fistm = new FileInputStream.from_file(fn);
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "WritePadCommand:Open file: Opened file for reading ...\n");

			PlainDocument pd = new PlainDocument();
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "WritePadCommand:Open file: Reading ...\n");

			pd.setInputStream(fistm);
			pd.tryReading();
			fistm.close();
			show(pd);

			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "WritePadCommand:Open file: Done.\n");
		} catch(IOStreamError.FileInputStreamError e) {
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "WritePadCommand:Open file: Could not open file\n");
			return -1;
		}
		return 0;
	}
}
/** @} */
