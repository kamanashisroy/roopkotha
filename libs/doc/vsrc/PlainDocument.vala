using aroop;
using shotodol;
using roopkotha;

/**
 * This is the base class for all the documents we render in roopkotha
 */
public class roopkotha.PlainDocument : RoopDocument {
	public PlainDocument() {
		base();
	}
	
	public void addLine(etxt*asciiData) {
		PlainContent c = new PlainContent(asciiData);
		contents.add(c);
	}
}
