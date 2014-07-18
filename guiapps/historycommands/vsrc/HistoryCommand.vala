using aroop;
using shotodol;

/** \addtogroup history_command
 *  @{
 */
internal class HistoryCommand : M100QuietCommand {
	enum Options {
		BACKTO = 1,
	}
	public HistoryCommand() {
		extring prefix = extring.set_static_string("history");
		base(&prefix);
		addOptionString("-b", M100Command.OptionType.INT, Options.BACKTO, "Number of stages to go back");
	}
	
	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		int back = 1;
		xtring? arg = vals[Options.BACKTO];
		if(arg != null) {
			back = arg.ecast().to_int();
		}
		if(back == 99) {
			extring quitEntry = extring.set_static_string("onQuit");
			extring output = extring();
			Plugin.swarm(&quitEntry, null, &output);
		} 
		extring output = extring.stack(512);
		output.printf("We do not know how to go back yet");
		pad.write(&output);
		return 0;
	}
}
/* @} */
