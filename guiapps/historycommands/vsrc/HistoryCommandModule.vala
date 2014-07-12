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
public class roopkotha.historycommands.HistoryCommandModule: DynamicModule {
	public HistoryCommandModule() {
		name = etxt.from_static("historycommand");
	}
	
	public override int init() {
		txt command = new txt.from_static("velacommand");
		Plugin.register(command, new M100Extension(new HistoryCommand(), this));
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new HistoryCommandModule();
	}
}
/* @} */
