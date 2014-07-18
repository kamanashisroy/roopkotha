using aroop;
using shotodol;

/** \addtogroup velapp
 *  @{
 */
public class roopkotha.velavanilla.VelaVanillaModule : DynamicModule {
	public static VelaVanillaScripted?vanilla;
	VelaVanillaModule() {
		extring name = extring.set_static_string("velavanilla");
		extring ver = extring.set_static_string("0.0.0");
		base(&name, &ver);
	}
	public override int init() {
		vanilla = new VelaVanillaScripted();
		extring command = extring.set_static_string("velacommand");
		Plugin.register(&command, new M100Extension(new VelaVeilCommand(vanilla), this));
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
