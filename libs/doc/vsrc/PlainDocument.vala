using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup doc
 *  @{
 */
public class roopkotha.doc.PlainDocument : roopkotha.doc.RoopDocument {
	int counter;
	LineInputStream? listrm;
	public PlainDocument() {
		counter = 0;
		listrm = null;
		base();
	}
	
	public void addLine(etxt*asciiData) {
		PlainContent c = new PlainContent(asciiData);
		etxt dlg = etxt.stack(128);
		dlg.printf("PlainDocument:Adding line:%s\n", asciiData.to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dlg);
		contents.set(counter++, c);
	}

	public void setInputStream(InputStream istrm) {
		listrm = new LineInputStream(istrm);
	}

	public void tryReading() {
		do {
			etxt data = etxt.stack(512);
			core.assert(listrm != null);
			int ln = listrm.read(&data);
			if(ln == 0) break;
			addLine(&data);
		} while(true);
	}
}
/** @} */
