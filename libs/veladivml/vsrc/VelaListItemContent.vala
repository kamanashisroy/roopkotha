using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup doc
 *  @{
 */
public class roopkotha.veladivml.VelaListItemContent : roopkotha.doc.AugmentedContent {
	txt data;
	bool focused;
	etxt href;
	public VelaListItemContent(etxt*asciiData, etxt*gHref, bool gFocused) {
		base();
		if(asciiData.is_empty_magical()) {
			data = new txt.from_static("");
		} else {
			data = new txt.memcopy_etxt(asciiData);
		}
		cType = ContentType.PLAIN_CONTENT;
		focused = gFocused;
		if(gHref != null)
			href = etxt.dup_etxt(gHref);
		else
			href = etxt.EMPTY();
	}
	public override void getText(etxt*tData) {
		tData.concat(data);
	}
	public override bool isFocused() {
		return focused;
	}

	public override bool hasAction() {
		return !href.is_empty();
	}

	public override void getAction(etxt*adata) {
		adata.destroy();
		(*adata) = etxt.same_same(&href);
	}
}
/** @} */
