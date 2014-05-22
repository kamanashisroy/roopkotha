using aroop;
using shotodol;

/** \addtogroup velapp
 *  @{
 */
public class roopkotha.velavanilla.VelaVanillaModule : ModulePlugin {
	public static VelaVanillaScripted?vanilla;
	public override int init() {
		vanilla = new VelaVanillaScripted();
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
