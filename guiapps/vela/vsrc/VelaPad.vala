using aroop;
using shotodol;
using roopkotha;
using roopkotha.vela;

/**
 * You can only trust the numbers. 
 * [-Maturity- 10]
 */
public class roopkotha.VelaPad : VelaPadMenu {
	public VelaPad() {
		base();
	}
	public int loadFile(etxt*fn) {
		Watchdog.logString("VelaPadCommand:Open file ...\n");
		try {
			FileInputStream fistm = new FileInputStream.from_file(fn);
			Watchdog.logString("VelaPadCommand:Open file: Opened file for reading ...\n");

			PageAppDocument pd = new PageAppDocument();
			Watchdog.logString("VelaPadCommand:Open file: Reading ...\n");

			pd.setInputStream(fistm);
			pd.tryReading();
			fistm.close();
			show(pd);

			Watchdog.logString("VelaPadCommand:Open file: Done.\n");
		} catch(IOStreamError.FileInputStreamError e) {
			Watchdog.logString("VelaPadCommand:Open file: Could not open file\n");
			return -1;
		}
		return 0;
	}
}
