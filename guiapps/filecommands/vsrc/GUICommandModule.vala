using aroop;
using shotodol;
using roopkotha.velavanilla;
using roopkotha.filecommands;

/**
 * \ingroup guiapps
 * \defgroup gui_command Commands that are capable of showing output in gui.
 */

/** \addtogroup gui_command
 *  @{
 */
public class roopkotha.filecommands.GUICommandModule: ModulePlugin {
	FileListCommand flcmd;
	DefaultFileResourceHandler fr;
	txt fopener;
	public GUICommandModule() {
		fopener = new txt.from_static("velafopen");
		flcmd = new FileListCommand();
		fr = new DefaultFileResourceHandler();
	}
	
	public override int init() {
		roopkotha.velavanilla.VelaVanillaModule.vanilla.velac.register(flcmd);
		roopkotha.velavanilla.VelaVanillaModule.vanilla.cHandler.setHandler(fopener, fr);
		return 0;
	}
	public override int deinit() {
		roopkotha.velavanilla.VelaVanillaModule.vanilla.velac.unregister(flcmd);
		roopkotha.velavanilla.VelaVanillaModule.vanilla.cHandler.setHandler(fopener, null);
		base.deinit();
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new GUICommandModule();
	}
}
/* @} */
