using aroop;
using shotodol;
using roopkotha;

/**
 * This is the base class for all the documents we render in roopkotha
 */
public class roopkotha.PlainDocument : RoopDocument {
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
		etxt data = etxt.stack(512);
		core.assert(listrm != null);
		while(listrm.read(&data) > 0) {
			addLine(&data);
		}
	}
}
