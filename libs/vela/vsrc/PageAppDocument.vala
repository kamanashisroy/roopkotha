using aroop;
using shotodol;
using roopkotha;
using roopkotha.vela;

/**
 * This is the base class for all the documents we render in roopkotha
 */
public class roopkotha.vela.PageAppDocument : RoopDocument {
	int counter;
	InputStream? instrm;
	public PageAppDocument() {
		counter = 0;
		instrm = null;
		base();
	}
	
	public void spellChunk(etxt*asciiData) {
		/* TODO parse xml content */
		HTMLMarkupContent c = new HTMLMarkupContent(asciiData);
		print("PlainDocument:Adding line:%s\n", asciiData.to_string());
		contents.set(counter++, c);
	}

	public void setInputStream(InputStream istrm) {
		instrm = istrm;
	}

	public void tryReading() {
		do {
			etxt data = etxt.stack(512);
			core.assert(instrm != null);
			int bytesRead = instrm.read(&data);
			if(bytesRead == 0) break;
			spellChunk(&data);
		} while(true);
	}
}
