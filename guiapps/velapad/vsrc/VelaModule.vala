using aroop;
using shotodol;

/** \addtogroup velapp
 *  @{
 */
public class roopkotha.velapad.VelaModule : ModulePlugin {
	VelaCommand cmd;
	public override int init() {
		cmd = new VelaCommand();
		CommandServer.server.cmds.register(cmd);
		return 0;
	}

	public override int deinit() {
		CommandServer.server.cmds.unregister(cmd);
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new VelaModule();
	}
}
/** @} */
