using aroop;
using shotodol;

/** \addtogroup guitest
 *  @{
 */
public class roopkotha.app.GUITestModule : DynamicModule {
	public GUITestModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() {
		extring test = extring.set_static_string("unittest");
		Plugin.register(&test, new AnyInterfaceExtension(new GUITest(), this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new GUITestModule();
	}
}
/** @} */
