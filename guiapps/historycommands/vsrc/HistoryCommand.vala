using aroop;
using shotodol;

/** \addtogroup history_command
 *  @{
 */
internal class HistoryCommand : M100QuietCommand {
	etxt prfx;
	enum Options {
		BACKTO = 1,
	}
	public HistoryCommand() {
		base();
		addOptionString("-b", M100Command.OptionType.INT, Options.BACKTO, "Number of stages to go back");
	}
	
	public override etxt*get_prefix() {
		prfx = etxt.from_static("history");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		int back = 1;
		txt? arg = vals[Options.BACKTO];
		if(arg != null) {
			back = arg.to_int();
		}
		if(back == 99) {
			MainTurbine.quit();
		} 
		etxt output = etxt.stack(512);
		output.printf("We do not know how to go back yet");
		pad.write(&output);
		return 0;
	}
}
/* @} */
