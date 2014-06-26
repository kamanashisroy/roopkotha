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
		etxt back = etxt.from_static("-b");
		etxt back_help = etxt.from_static("Number of stages to go back");
		addOption(&back, M100Command.OptionType.INT, Options.BACKTO, &back_help);
	}
	
	public override etxt*get_prefix() {
		prfx = etxt.from_static("history");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		SearchableSet<txt> vals = SearchableSet<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		int back = 1;
		container<txt>? mod = null;
		mod = vals.search(Options.BACKTO, match_all);
		if(mod != null) {
			back = mod.get().to_int();
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
