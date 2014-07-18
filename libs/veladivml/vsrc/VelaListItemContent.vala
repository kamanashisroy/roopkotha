using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup doc
 *  @{
 */
public class roopkotha.veladivml.VelaListItemContent : roopkotha.doc.AugmentedContent {
	extring data;
	bool focused;
	extring href;
	public VelaListItemContent(extring*asciiData, extring*gHref, bool gFocused) {
		base();
		if(asciiData.is_empty_magical()) {
			data = extring.set_static_string("");
		} else {
			data = extring.copy_on_demand(asciiData);
		}
		cType = ContentType.PLAIN_CONTENT;
		focused = gFocused;
		if(gHref != null)
			href = extring.copy_on_demand(gHref);
		else
			href = extring();
	}
	public override void getTextAs(extring*tData) {
		tData.rebuild_and_copy_shallow(&data);
	}
	public override bool isFocused() {
		return focused;
	}

	public override bool hasAction() {
		return !href.is_empty();
	}

	public override void getActionAs(extring*adata) {
		adata.rebuild_and_copy_shallow(&href);
	}
}
/** @} */
