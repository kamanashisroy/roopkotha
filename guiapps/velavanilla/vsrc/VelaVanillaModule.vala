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
		extring command = extring.set_static_string("velacommand");
		Plugin.register(&command, new M100Extension(new VelaVeilCommand(vanilla), this));
		extring rehash = extring.set_static_string("rehash");
		Plugin.register(&rehash, new HookExtension(rehashHook, this));
		rehashHook(null, null);
		return 0;
	}

	int rehashHook(extring*msg, extring*output) {
		extring command = extring.set_static_string("velacommand");
		Extension?root = Plugin.get(&command);
		vanilla.velac.rehash(root);
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
