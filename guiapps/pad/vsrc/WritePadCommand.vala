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
	etxt prfx;
	WritePad? wpad;
	enum Options {
		INFILE = 1,
		OUTFILE,
	}
	public WritePadCommand() {
		base();
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Input file.");
		addOptionString("-o", M100Command.OptionType.TXT, Options.OUTFILE, "Output file."); 
		wpad = null;
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("writepad");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		txt?infile = vals[Options.INFILE];
		if(infile != null) {
			if(wpad == null) {
				wpad = new WritePad();
			}
			if(wpad.loadFile(infile) != 0) {
				throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Could not open file");
			}
			return 0;
		}
		txt?outfile = vals[Options.OUTFILE];
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
