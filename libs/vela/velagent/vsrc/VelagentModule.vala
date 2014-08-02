using aroop;
using shotodol;
using roopkotha.vela;
using roopkotha.velagent;

/** \addtogroup velagent
 *  @{
 */
public class roopkotha.velagent.VelagentModule : Module {
	VelaRebound agent;
	public VelagentModule() {
		extring nm = extring.set_static_string("velagent");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
		agent = new VelaRebound();
	}

	public override int init() {
		extring entry = extring.set_static_string("rehash"); // say we need rehash
		Plugin.register(&entry, new HookExtension(rehashHook, this));
		return 0;
	}

	int rehashHook(extring*msg, extring*output) {
		// remove all previous handlers and pages
		agent.plugPage(null);agent.plugHandler(null);
		if(loadHandler() != -1) // load the handler
			loadPage(); // load the page
		return 0;
	}

	int loadPage() {
		extring pgcb = extring.set_static_string("vela/page");
		AnyInterfaceExtension pageExtension = (AnyInterfaceExtension)Plugin.get(&pgcb);
		if(pageExtension == null)
			return -1;
		PageWindow page = (PageWindow)pageExtension.getInterface(null);
		agent.plugPage(page);
		return 0;
	}

	int loadHandler() {
		extring pageHandler = extring.set_static_string("vela/page/handler");
		AnyInterfaceExtension handlerExtension = (AnyInterfaceExtension)Plugin.get(&pageHandler);
		if(handlerExtension == null)
			return -1;
		VelaResourceHandler handler = (VelaResourceHandler)handlerExtension.getInterface(null);
		agent.plugHandler(handler);
		return 0;
	}

	public override int deinit() {
		Plugin.unregisterModule(this);
		base.deinit();
		return 0;
	}
}
