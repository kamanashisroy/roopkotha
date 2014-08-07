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
		Plugin.acceptVisitor(&pgcb, (x) => {
			PageWindow page = (PageWindow)x.getInterface(null);
			agent.plugPage(page);
		});
		return 0;
	}

	int loadHandler() {
		extring pageHandler = extring.set_static_string("vela/page/handler");
		Plugin.acceptVisitor(&pageHandler, (x) => {
			VelaResourceHandler handler = (VelaResourceHandler)x.getInterface(null);
			agent.plugHandler(handler);
		});
		return 0;
	}

	public override int deinit() {
		Plugin.unregisterModule(this);
		base.deinit();
		return 0;
	}
}
