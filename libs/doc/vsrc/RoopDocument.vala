using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup doc
 *  @{
 */
/**
 * This is the base class for all the documents we render in roopkotha
 */
public class roopkotha.doc.RoopDocument : Replicable {
	public ArrayList<AugmentedContent> contents;
	public RoopDocument() {
		contents = ArrayList<AugmentedContent>();
	}
	~RoopDocument() {
		contents.destroy();
	}
}
/** @} */
