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
	etxt prfx;
	VelaPad? vpad;
	enum Options {
		INFILE = 1,
		OUTFILE,
	}
	public VelaCommand(Module src) {
		base();
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input file");
		vpad = new VelaPad();
		txt entry = new txt.from_static("MainTurbine");
		Plugin.register(entry, new AnyInterfaceExtension(vpad.impl, src));
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("velalynx");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		txt?infile = vals[Options.INFILE];
		if(infile != null) {
			if(vpad.loadFile(infile) != 0) {
				throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Could not open file");
			}
			return 0;
		}
		txt?outfile = vals[Options.OUTFILE];
		if(outfile != null) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Unimplemented");
		}
		return 0;
	}
}
/** @} */
