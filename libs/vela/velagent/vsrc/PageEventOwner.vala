
using aroop;
using shotodol;
using onubodh;
using roopkotha.gui;
using roopkotha.vela;

/** \addtogroup velagent
 *  @{
 */
public class roopkotha.velagent.PageEventOwner : roopkotha.gui.EventOwner {
	public extring action;
	public PageEventOwner(extring*gAction,extring*displayText, Replicable?src) {
		base(src, displayText);
		if(gAction == null) {
			action = extring();
		} else {
			action = extring.copy_on_demand(gAction);
		}
	}
}

/** @} */
