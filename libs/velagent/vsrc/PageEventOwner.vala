
using aroop;
using shotodol;
using onubodh;
using roopkotha.gui;
using roopkotha.vela;

/** \addtogroup velagent
 *  @{
 */
public class roopkotha.velagent.PageEventOwner : roopkotha.gui.EventOwner {
	public etxt action;
	public PageEventOwner(etxt*gAction,etxt*displayText, Replicable?src) {
		base(src, displayText);
		if(gAction == null) {
			action = etxt.EMPTY();
		} else {
			action = etxt.dup_etxt(gAction);
		}
	}
}

/** @} */
