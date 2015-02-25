using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup gui
 *  @{
 */
public class roopkotha.gui.GUICoreModule : Module {
	public static GUICore? gcore;
	public static BagFactory? bagBuilder;
	public GUICoreModule() {
		extring nm = extring.set_static_string("guicore");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
		gcore = null;
		bagBuilder = null;
	}

	public override int init() {
		extring x = extring.set_static_string("rehash");
		PluginManager.register(&x, new HookExtension(rehashHook, this));
		rehashHook(null, null); // I do not know if it good, we are just trying to load all the existing extensions .
		return 0;
	}

	int rehashHook(extring*msg, extring*output) {
		gcore = null;
		bagBuilder = null;
		extring ex = extring.set_static_string("gcore");
		PluginManager.acceptVisitor(&ex, (x) => {
			gcore = (GUICore)x.getInterface(null);
		});
		ex.rebuild_and_set_static_string("bag/factory");
		PluginManager.acceptVisitor(&ex, (x) => {
			bagBuilder = (BagFactory)x.getInterface(null);
		});
		return 0;
	}

	public override int deinit() {
		gcore = null;
		bagBuilder = null;
		base.deinit();
		return 0;
	}
}
