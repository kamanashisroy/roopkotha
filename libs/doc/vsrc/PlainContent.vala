using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup doc
 *  @{
 */
public class roopkotha.doc.PlainContent : roopkotha.doc.AugmentedContent {
	extring data;
	public PlainContent(extring*asciiData) {
		base();
		data = extring.copy_on_demand(asciiData);
		cType = ContentType.PLAIN_CONTENT;
	}
	public override void getTextAs(extring*tData) {
		tData.rebuild_and_copy_shallow(&data);
	}
}
/** @} */
