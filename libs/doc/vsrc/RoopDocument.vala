using aroop;
using shotodol;
using roopkotha;

/**
 * This is the base class for all the documents we render in roopkotha
 */
public class roopkotha.RoopDocument : Replicable {
	internal ArrayList<AugmentedContent> contents;
	public RoopDocument() {
		contents = ArrayList<AugmentedContent>();
	}
	~RoopDocument() {
		contents.destroy();
	}
}
