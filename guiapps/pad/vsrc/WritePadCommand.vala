using aroop;
using shotodol;
using roopkotha;

/**
 * \ingroup command 
 * \defgroup textcommand Text based commands
 */
/**
 * \ingroup doc
 * \defgroup padapp Simple application based on doc module.
 */

/** \addtogroup padapp
 *  @{
 */
/** \ingroup textcommand */
public class roopkotha.app.WritePadCommand : M100Command {
	WritePad? wpad;
	unowned Module mod;
	enum Options {
		INFILE = 1,
		OUTFILE,
	}
	public WritePadCommand(Module src) {
		extring prefix = extring.set_static_string("writepad");
		base(&prefix);
		mod = src;
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input file.");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output file."); 
		wpad = null;
	}


	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?infile = vals[Options.INFILE];
		if(infile != null) {
			if(wpad == null) {
				wpad = new WritePad();
			}
			if(wpad.loadFile(infile) != 0) {
				throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Could not open file");
			}
			return 0;
		}
		xtring?outfile = vals[Options.OUTFILE];
		if(outfile != null) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Unimplemented");
		}
		if(wpad == null) {
			wpad = new WritePad();
		}
		return 0;
	}
}
/** @} */
