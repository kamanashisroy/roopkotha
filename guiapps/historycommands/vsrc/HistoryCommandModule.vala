using aroop;
using shotodol;
using roopkotha.velavanilla;

/**
 * \ingroup guiapps
 * \defgroup history_command These are the commands to navigate through the vela page history.
 */

/** \addtogroup history_command
 *  @{
 */
public class roopkotha.historycommands.HistoryCommandModule: ModulePlugin {
	HistoryCommand hc;
	public HistoryCommandModule() {
		hc = new HistoryCommand();
	}
	
	public override int init() {
		roopkotha.velavanilla.VelaVanillaModule.vanilla.velac.register(hc);
		return 0;
	}
	public override int deinit() {
		roopkotha.velavanilla.VelaVanillaModule.vanilla.velac.unregister(hc);
		base.deinit();
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new HistoryCommandModule();
	}
}
/* @} */
