using aroop;
using shotodol;
using roopkotha;
using roopkotha.vela;

/** \addtogroup velagent;
 *  @{
 */
public abstract class roopkotha.velagent.CommandResourceLoader : VelaResourceLoader {
	StandardOutputStream sout;
	public CommandResourceLoader() {
		sout = new StandardOutputStream();
	}
	~CommandResourceLoader() {
	}
	public override int request(VelaResource id) {
		etxt prefix = etxt.stack(64);
		id.getPrefix(&prefix);
		int len = prefix.length();
		etxt cmdTxt = etxt.same_same(&id.url);
		cmdTxt.shift(len+3);
		print("We should execute command %s\n", cmdTxt.to_string());
		//CommandServer.server.cmds.act_on(&cmdTxt, sout);
		return 0;
	}
}
/** @} */
