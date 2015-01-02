using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup guiimpl
 *  @{
 */
public class roopkotha.gui.GUICoreModuleImpl : DynamicModule {
	GUICoreModuleImpl() {
		extring nm = extring.set_static_string("guiimpl");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() {
		GUICoreImpl impl = new GUICoreImpl();
		extring entry = extring.set_static_string("MainFiber");
		Plugin.register(&entry, new AnyInterfaceExtension(impl, this));
		entry.rebuild_and_set_static_string("gcore");
		Plugin.register(&entry, new AnyInterfaceExtension(impl, this));
		ModuleLoader.singleton.loadStatic(new GUICoreModule());
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new GUICoreModuleImpl();
	}
}
/** @} */
