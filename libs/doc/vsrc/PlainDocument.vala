using aroop;
using shotodol;
using roopkotha.gui;

/**
 * This is the base class for all the documents we render in roopkotha
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
		print("PlainDocument:Adding line:%s\n", asciiData.to_string());
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
