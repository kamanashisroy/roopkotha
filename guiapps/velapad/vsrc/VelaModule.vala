using aroop;
using shotodol;

/** \addtogroup velapp
 *  @{
 */
public class roopkotha.velapad.VelaModule : DynamicModule {
	VelaModule() {
		name = etxt.from_static("vela");
	}
	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new VelaCommand(this), this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new VelaModule();
	}
}
/** @} */
