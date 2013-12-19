using aroop;
using shotodol;
using roopkotha;

/**
 * This is the base class for all the documents we render in roopkotha
 */
public class roopkotha.PlainDocument : RoopDocument {
	int counter;
	public PlainDocument() {
		counter = 0;
		base();
	}
	
	public void addLine(etxt*asciiData) {
		PlainContent c = new PlainContent(asciiData);
		print("PlainDocument:Adding line:%s\n", asciiData.to_string());
		contents.set(counter++, c);
	}
}
