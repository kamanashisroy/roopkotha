using aroop;
using shotodol;

/** \addtogroup velapp
 *  @{
 */
public class roopkotha.velavanilla.VelaVanillaModule : DynamicModule {
	public static VelaVanillaScripted?vanilla;
	VelaVanillaModule() {
		extring name = extring.set_static_string("velavanilla");
		extring ver = extring.set_static_string("0.0.0");
		base(&name, &ver);
	}
	public override int init() {
		vanilla = new VelaVanillaScripted();
		extring command = extring.set_static_string("vela/command");
		Plugin.register(&command, new M100Extension(new VelaVeilCommand(vanilla), this));
		extring rehash = extring.set_static_string("rehash");
		Plugin.register(&rehash, new HookExtension(rehashHook, this));
		rehashHook(null, null);
		return 0;
	}

	int rehashHook(extring*msg, extring*output) {
		extring command = extring.set_static_string("vela/command");
		Extension?root = Plugin.get(&command);
		vanilla.velac.rehash(root);
		extring veil = extring.set_static_string("velaveil");
		extring outml = extring();
		Plugin.swarm(&veil, &veil, &outml);
		extring content = extring.stack_copy_deep(&outml);
		extring space = extring.set_static_string(" ");
		do {
			extring next = extring.copy_shallow(&content);
			int i = 0;
			for(i = 0;i < next.length() && next.char_at(i) != '\n';i++);
			content.shift(i);
			next.trim_to_length(i);
			if(next.is_empty()) break;
			print("line [%s]\n", next.to_string());
			extring name = extring();
			LineAlign.next_token_delimitered_sliteral(&next, &name, &space);
			if(name.is_empty() || next.is_empty()) continue;
			xtring path = new xtring.copy_deep(&name);
			xtring menuml = new xtring.copy_deep(&next);
			print("path %s .. menu %s\n", path.fly().to_string(), menuml.fly().to_string());
			vanilla.addVeil(path, menuml);
		} while(true);
		return 0;
	}

	public override int deinit() {
		vanilla = null;
		base.deinit();
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new VelaVanillaModule();
	}
}
/** @} */
