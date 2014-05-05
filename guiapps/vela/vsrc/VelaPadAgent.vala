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
		CommandResourceLoader loader = new CommandResourceLoader.givenCommandSet(CommandServer.server.cmds);
		agent = new Velagent(loader);
	}
	protected void setupAgent(PageView pg) {
		agent.plugPage(pg);
		//etxt menuML = etxt.from_static("<menu><x href=\"goback\" label=\"Back\"></x><x href=\"quit\" label=\"Quit\"></x><x href=\"aboutme\" label=\"About\"></x><x href=\"opennew\" label=\"Open\"></x><x href=\"close\" label=\"Close\"></x></menu>");
		etxt menuML = etxt.from_static("<m><x href=goback label=Back></x><x href=quit label=Quit></x><x href=aboutme label=About></x><x href=opennew label=Open></x><x href=close label=Close></x></m>");
		agent.plugMenu(&menuML);
	}

}
/** @} */
