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
public class roopkotha.filecommands.GUICommandModule: DynamicModule {
	public GUICommandModule() {
		name = etxt.from_static("filecommand");
	}
	
	public override int init() {
		txt command = new txt.from_static("velacommand");
		Plugin.register(command, new M100Extension(new FileListCommand(), this));
		txt fopener = new txt.from_static("velafopen");
		Plugin.register(command, new AnyInterfaceExtension(new DefaultFileResourceHandler(), this));
		//roopkotha.velavanilla.VelaVanillaModule.vanilla.cHandler.setHandler(fopener, fr);
		//fr.setHandlers();
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new GUICommandModule();
	}
}
/* @} */
