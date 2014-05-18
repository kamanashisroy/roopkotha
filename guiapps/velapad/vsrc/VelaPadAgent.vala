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
internal class roopkotha.velapad.VelaPadAgent : Replicable {
	Velagent agent;
	public VelaPadAgent() {
		agent = new VelaPadXpress();
	}
	protected void setupAgent(PageView pg) {
		agent.plugPage(pg);
	}

}
/** @} */
