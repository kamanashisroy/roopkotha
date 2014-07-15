using aroop;
using shotodol;

/** \addtogroup padapp
 *  @{
 */
public class roopkotha.app.WritePadModule : DynamicModule {
	public WritePadModule() {
		name = etxt.from_static("writepad");
	}
	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new WritePadCommand(this), this));
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
