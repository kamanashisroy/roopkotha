using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.doc;
using roopkotha.vela;

/** \addtogroup velapp
 *  @{
 */
/**
 * You can only trust the numbers. 
 * [-Maturity- 10]
 */
internal class roopkotha.app.VelaPad : VelaPadMenu {
	public VelaPad() {
		base();
	}
	public int loadFile(etxt*fn) {
		Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), "VelaPadCommand:Open file ...\n");
		try {
			FileInputStream fistm = new FileInputStream.from_file(fn);
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), "VelaPadCommand:Open file: Opened file for reading ...\n");

			PageAppDocument pd = new PageAppDocument();
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), "VelaPadCommand:Open file: Reading ...\n");

			pd.setInputStream(fistm);
			pd.tryReading();
			fistm.close();
			show(pd);

			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), "VelaPadCommand:Open file: Done.\n");
		} catch(IOStreamError.FileInputStreamError e) {
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), "VelaPadCommand:Open file: Could not open file\n");
			return -1;
		}
		return 0;
	}
}
/** @} */
