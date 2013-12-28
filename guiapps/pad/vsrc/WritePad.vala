using aroop;
using shotodol;
using roopkotha;

public class roopkotha.WritePad : WritePadMenu {
	public WritePad() {
		base();
	}
	public int loadFile(etxt*fn) {
		Watchdog.logString("WritePadCommand:Open file ...\n");
		try {
			FileInputStream fistm = new FileInputStream.from_file(fn);
			Watchdog.logString("WritePadCommand:Open file: Opened file for reading ...\n");

			PlainDocument pd = new PlainDocument();
			Watchdog.logString("WritePadCommand:Open file: Reading ...\n");

			pd.setInputStream(fistm);
			pd.tryReading();
			fistm.close();
			show(pd);

			Watchdog.logString("WritePadCommand:Open file: Done.\n");
		} catch(IOStreamError.FileInputStreamError e) {
			Watchdog.logString("WritePadCommand:Open file: Could not open file\n");
			return -1;
		}
		return 0;
	}
}
