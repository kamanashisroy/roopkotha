using aroop;
using shotodol;
using roopkotha;
using roopkotha.veladivml;
using roopkotha.velagent;

public class roopkotha.filecommands.VelaAppFileResourceHandler : VelaResourceHandler {
	public VelaAppFileResourceHandler() {
		base();
	}
	public override int request(VelaResource id) {
		Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "VelaPadCommand:Open file ...\n");
		etxt prefix = etxt.stack(id.url.length());
		id.copyPrefix(&prefix);
		etxt fn = etxt.same_same(&id.url);
		fn.shift(prefix.length());
		try {
			FileInputStream fistm = new FileInputStream.from_file(&fn);
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "VelaPadCommand:Open file: Opened file for reading ...\n");

			VelaDivDocument doc = new VelaDivDocument();
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "VelaPadCommand:Open file: Reading ...\n");

			doc.setInputStream(fistm);
			doc.tryReading();
			fistm.close();
			onContentReady(id, doc);

			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "VelaPadCommand:Open file: Done.\n");
		} catch(IOStreamError.FileInputStreamError e) {
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "VelaPadCommand:Open file: Could not open file\n");
			return -1;
		}
		return 0;
	}
}
