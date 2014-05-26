using aroop;
using shotodol;
using onubodh;
using roopkotha;
using roopkotha.vela;

/** \addtogroup veladivml
 *  @{
 */
/**
 * You can only trust the numbers. 
 * [-Maturity- 1]
 */
public class roopkotha.veladivml.VelaDivContent : roopkotha.velarichml.VelaRichContent {
	bool focused;
	etxt href;
	public VelaDivContent(etxt*asciiData, etxt*gHref, bool gFocused) {
		base(asciiData);
		focused = gFocused;
		if(gHref != null)
			href = etxt.dup_etxt(gHref);
		else
			href = etxt.EMPTY();
	}

	public override bool isFocused() {
		return focused;
	}

	public override bool isActive() {
		return !href.is_empty();
	}

	public override void getAction(etxt*data) {
		(*data) = etxt.same_same(&href);
	}
}


/** @} */
