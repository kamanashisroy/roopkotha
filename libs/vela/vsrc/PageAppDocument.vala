using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.doc;
using roopkotha.vela;

/**
 * You can only trust the numbers. 
 * [-Maturity- 30]
 */
/**
 * This is the base class for all the documents we render in roopkotha
 */
public class roopkotha.vela.PageAppDocument : roopkotha.doc.RoopDocument {
	int counter;
	InputStream? instrm;
	public PageAppDocument() {
		counter = 0;
		instrm = null;
		base();
	}
	
	public virtual void spellChunk(etxt*asciiData) {
		HTMLMarkupContent c = new HTMLMarkupContent(asciiData);
		print("PlainDocument:Adding line:%s\n", asciiData.to_string());
		contents.set(counter++, c);
	}

	public void setInputStream(InputStream istrm) {
		instrm = istrm;
	}

	public void tryReading() {
		do {
#if LOW_MEMORY
			etxt data = etxt.stack(1024);
#else
			etxt data = etxt.stack(1<<12);
#endif
			core.assert(instrm != null);
			try {
				int bytesRead = instrm.read(&data);
				if(bytesRead == 0) break;
				spellChunk(&data);
			} catch(IOStreamError.InputStreamError e) {
				break;
			}
		} while(true);
	}
}
