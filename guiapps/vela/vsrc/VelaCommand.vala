using aroop;
using shotodol;
using roopkotha;

/**
 * You can only trust the numbers. 
 * [-Maturity- 10]
 */
public class onubodh.VelaCommand : M100Command {
	etxt prfx;
	VelaPad? vpad;
	enum Options {
		INFILE = 1,
		OUTFILE,
	}
	public VelaCommand() {
		base();
		etxt input = etxt.from_static("-i");
		etxt input_help = etxt.from_static("Input file");
		addOption(&input, M100Command.OptionType.TXT, Options.INFILE, &input_help);
		vpad = null;
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("velalynx");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		int ecode = 0;
		SearchableSet<txt> vals = SearchableSet<txt>();
		parseOptions(cmdstr, &vals);
		do {
			container<txt>? mod;
			if((mod = vals.search(Options.INFILE, match_all)) != null) {
				unowned txt infile = mod.get();
				if(vpad == null) {
					vpad = new VelaPad();
				}
				if(vpad.loadFile(infile) != 0) {
					break;
				}
				bye(pad, true);
				return 0;
			}
			if((mod = vals.search(Options.OUTFILE, match_all)) != null) {
				unowned txt outfile = mod.get();
				print("unimplemented\n");
				break;
			}
			if(vpad == null) {
				vpad = new VelaPad();
			}
			bye(pad, true);
		} while(false);
		bye(pad, false);
		return 0;
	}
}
