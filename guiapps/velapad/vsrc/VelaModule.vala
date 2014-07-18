using aroop;
using shotodol;

/** \addtogroup velapp
 *  @{
 */
public class roopkotha.velapad.VelaModule : DynamicModule {
	VelaModule() {
		extring nm = extring.set_static_string("vela");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() {
		extring command = extring.set_static_string("command");
		Plugin.register(&command, new M100Extension(new VelaCommand(this), this));
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
