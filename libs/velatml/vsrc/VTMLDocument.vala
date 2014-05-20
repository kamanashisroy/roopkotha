using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.doc;
using roopkotha.vela;

/**
 * \ingroup vela
 * \defgroup velatml HTML like markup content support to display application controls.
 */

/** \addtogroup velatml
 *  @{
 */
/**
 * You can only trust the numbers. 
 * [-Maturity- 30]
 */
/**
 * This is the base class for all the documents we render in roopkotha
 */
public class roopkotha.velatml.VTMLDocument : roopkotha.doc.RoopDocument {
	int counter;
	InputStream? instrm;
	public VTMLDocument() {
		counter = 0;
		instrm = null;
		base();
	}
	
	public virtual void spellChunk(etxt*asciiData) {
		VTMLContent c = new VTMLContent(asciiData);
		//print("VTMLContent:Adding line:%s\n", asciiData.to_string());
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
/** @} */
