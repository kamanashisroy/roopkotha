using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.vela;
using roopkotha.velagent;

/** \addtogroup velapp
 *  @{
 */
/**
 * You can only trust the numbers. 
 * [-Maturity- 0]
 */
internal class roopkotha.app.VelaPadAgent : Replicable {
	Velagent agent;
	public VelaPadAgent() {
		agent = new VelaExpress();
	}
	protected void setupAgent(PageView pg) {
		agent.plugPage(pg);
	}

}
/** @} */
