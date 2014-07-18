using aroop;
using shotodol;

/** \addtogroup padapp
 *  @{
 */
public class roopkotha.app.WritePadModule : DynamicModule {
	public WritePadModule() {
		extring nm = extring.set_static_string("writepad");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() {
		extring command = extring.set_static_string("command");
		Plugin.register(&command, new M100Extension(new WritePadCommand(this), this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new WritePadModule();
	}
}
/** @} */
