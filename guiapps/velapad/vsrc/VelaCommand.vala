using aroop;
using shotodol;
using roopkotha;

/** \ingroup vela
 * \defgroup velapp Simple application based on vela
 *  \addtogroup velapp
 *  @{
 */
/**
 * You can only trust the numbers. 
 * [-Maturity- 10]
 */
/** \ingroup textcommand */
internal class roopkotha.velapad.VelaCommand : M100Command {
	public VelaPad? vpad;
	enum Options {
		INFILE = 1,
		OUTFILE,
	}
	public VelaCommand(Module src) {
		extring prefix = extring.set_static_string("velalynx");
		base(&prefix);
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input file");
		vpad = new VelaPad();
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?infile = vals[Options.INFILE];
		if(infile != null) {
			if(vpad.loadFile(infile) != 0) {
				throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Could not open file");
			}
			return 0;
		}
		xtring?outfile = vals[Options.OUTFILE];
		if(outfile != null) {
			// TODO dump content
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Unimplemented");
		}
		return 0;
	}
}
/** @} */
