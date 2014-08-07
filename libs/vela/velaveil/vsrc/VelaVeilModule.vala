using aroop;
using shotodol;
using roopkotha.vela;
using roopkotha.velagent;

/** \addtogroup velaveil
 *  @{
 */
public class roopkotha.velawidget.VelaVeilModule : Module {
	VelaVeil veil;
	public VelaVeilModule() {
		extring nm = extring.set_static_string("velaveil");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
		veil = new VelaVeil();
	}

	public override int init() {
		extring entry = extring.set_static_string("vela/command");
		Plugin.register(&entry, new M100Extension(new VelaVeilCommand(veil), this));
		entry.rebuild_and_set_static_string("vela/onContentDisplay");
		Plugin.register(&entry, new HookExtension(onContentDisplayHook, this));
		entry.rebuild_and_set_static_string("rehash");
		Plugin.register(&entry, new HookExtension(rehashHook, this));
		return 0;
	}

	int onContentDisplayHook(extring*msg, extring*output) {
		print("we should register menu for %s\n", msg.to_string());
		veil.onContentDisplay(msg);
		return 0;
	}

	int rehashHook(extring*msg, extring*output) {
		/**
		 * Load page, handler and veils/menues
		 */
		if(loadPage() != -1 && loadHandler() != -1)
			loadVeil();
		return 0;
	}

	int loadPage() {
		extring pgcb = extring.set_static_string("vela/page");
		Plugin.acceptVisitor(&pgcb, (x) => {
			PageWindow page = (PageWindow)x.getInterface(null);
			veil.plugPage(page);
		});
		return 0;
	}

	int loadHandler() {
		extring pageHandler = extring.set_static_string("vela/page/handler");
		Plugin.acceptVisitor(&pageHandler, (x) => {
			VelaResourceHandler handler = (VelaResourceHandler)x.getInterface(null);
			veil.plugHandler(handler);
		});
		return 0;
	}

	int loadVeil() {
		/**
		 * Each menu consits of a key and value. The key and value is seperated by a space. And each key-value pair ends with a newline.
		 * Example:
		 * default <x href=\"velaxecute://ls\" label=Open></x><x href=\"velaxecute://history -b 99 \" label=Quit></x><x href=\"velafopen://about.vapp\" label=About></x>\n
		 * 
		 */
		extring entry = extring.set_static_string("vela/veil");
		extring outml = extring();
		Plugin.swarm(&entry, &entry, &outml);
		extring content = extring.stack_copy_deep(&outml);
		extring space = extring.set_static_string(" ");
		do {
			extring next = extring.copy_shallow(&content);
			int i = 0;
			for(i = 0;i < next.length() && next.char_at(i) != '\n';i++);
			content.shift(i);
			next.trim_to_length(i);
			if(next.is_empty()) break;
			extring name = extring();
			LineAlign.next_token_delimitered_sliteral(&next, &name, &space);
			if(name.is_empty() || next.is_empty()) continue;
			xtring path = new xtring.copy_deep(&name);
			xtring menuml = new xtring.copy_deep(&next);
			veil.addVeil(path, menuml);
		} while(true);
		return 0;
	}

	public override int deinit() {
		Plugin.unregisterModule(this);
		base.deinit();
		return 0;
	}
}
