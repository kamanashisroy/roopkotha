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
		etxt input = etxt.from_static("-i");
		etxt input_help = etxt.from_static("Input file");
		etxt output = etxt.from_static("-o");
		etxt output_help = etxt.from_static("Output file");
		addOption(&input, M100Command.OptionType.TXT, Options.INFILE, &input_help);
		addOption(&output, M100Command.OptionType.TXT, Options.OUTFILE, &output_help); 
		wpad = null;
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("writepad");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		int ecode = 0;
		SearchableSet<txt> vals = SearchableSet<txt>();
		parseOptions(cmdstr, &vals);
		container<txt>? mod;
		if((mod = vals.search(Options.INFILE, match_all)) != null) {
			unowned txt infile = mod.get();
			if(wpad == null) {
				wpad = new WritePad();
			}
			if(wpad.loadFile(infile) != 0) {
				throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Could not open file");
			}
			return 0;
		}
		if((mod = vals.search(Options.OUTFILE, match_all)) != null) {
			unowned txt outfile = mod.get();
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Unimplemented");
		}
		if(wpad == null) {
			wpad = new WritePad();
		}
		return 0;
	}
}
/** @} */
