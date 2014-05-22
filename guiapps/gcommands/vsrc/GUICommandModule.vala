using aroop;
using shotodol;

/**
 * \ingroup guiapps
 * \defgroup gui_command Commands that are capable of showing output in gui.
 */

/** \addtogroup gui_command
 *  @{
 */
public class shotodol.GUICommandModule: ModulePlugin {
	FileListCommand flcmd;
	public GUICommandModule() {
		flcmd = new FileListCommand();
	}
	
	public override int init() {
		roopkotha.velavanilla.VelaVanillaModule.vanilla.velac.register(flcmd);
		return 0;
	}
	public override int deinit() {
		roopkotha.velavanilla.VelaVanillaModule.vanilla.velac.unregister(flcmd);
		base.deinit();
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new GUICommandModule();
	}
}
/* @} */