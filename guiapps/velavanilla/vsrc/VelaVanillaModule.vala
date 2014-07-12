using aroop;
using shotodol;

/** \addtogroup velapp
 *  @{
 */
public class roopkotha.velavanilla.VelaVanillaModule : DynamicModule {
	public static VelaVanillaScripted?vanilla;
	VelaVanillaModule() {
		name = etxt.from_static("velavanilla");
	}
	public override int init() {
		vanilla = new VelaVanillaScripted();
		txt command = new txt.from_static("velacommand");
		Plugin.register(command, new M100Extension(new VelaVeilCommand(vanilla), this));
		return 0;
	}

	public override int deinit() {
		vanilla = null;
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new VelaVanillaModule();
	}
}
/** @} */
