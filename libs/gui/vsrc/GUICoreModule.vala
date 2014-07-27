using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup gui
 *  @{
 */
public class roopkotha.gui.GUICoreModule : Module {
	public static GUICore? gcore;
	public GUICoreModule() {
		extring nm = extring.set_static_string("guicore");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
		gcore = null;
	}

	public override int init() {
		extring x = extring.set_static_string("rehash");
		Plugin.register(&x, new HookExtension(rehashHook, this));
		rehashHook(null, null); // I do not know if it good, we are just trying to load all the existing extensions .
		return 0;
	}

	int rehashHook(extring*msg, extring*output) {
		extring x = extring.set_static_string("gcore");
		Extension?root = Plugin.get(&x);
		while(root != null) {
			gcore = (GUICore)root.getInterface(null);
			Extension?next = root.getNext();
			root = next;
		}
		return 0;
	}

	public override int deinit() {
		gcore = null;
		base.deinit();
		return 0;
	}
}
