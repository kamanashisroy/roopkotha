using aroop;
using shotodol;
using roopkotha;

public class onubodh.WritePadCommand : M100Command {
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

	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		int ecode = 0;
		SearchableSet<txt> vals = SearchableSet<txt>();
		parseOptions(cmdstr, &vals);
		do {
			container<txt>? mod;
			if((mod = vals.search(Options.INFILE, match_all)) != null) {
				unowned txt infile = mod.get();
				if(wpad == null) {
					wpad = new WritePad();
				}
				if(wpad.loadFile(infile) != 0) {
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
			if(wpad == null) {
				wpad = new WritePad();
			}
		} while(false);
		bye(pad, false);
		return 0;
	}
}
