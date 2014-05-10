using aroop;
using shotodol;
using shotodol_platform_fileutils;

/** \addtogroup gui_command
 *  @{
 */
internal class shotodol.FileListCommand : M100Command {
	etxt prfx;
	enum Options {
		GUI = 1,
		PATH,
	}
	public FileListCommand() {
		base();
		etxt gui = etxt.from_static("-gui");
		etxt gui_help = etxt.from_static("show output for gui rendering");
		etxt path = etxt.from_static("-p");
		etxt path_help = etxt.from_static("Path");
		addOption(&path, M100Command.OptionType.TXT, Options.PATH, &path_help);
		addOption(&gui, M100Command.OptionType.NONE, Options.GUI, &gui_help);
	}
	
	public override etxt*get_prefix() {
		prfx = etxt.from_static("ls");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		SearchableSet<txt> vals = SearchableSet<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			desc(CommandDescType.COMMAND_DESC_FULL, pad);
			bye(pad, false);
			return 0;
		}
		bool gui = false;
		unowned txt?path = null;
		container<txt>? mod = vals.search(Options.GUI, match_all);
		if(mod != null) {
			gui = true;
		}
		mod = vals.search(Options.PATH, match_all);
		if(mod != null) {
			path = mod.get();
		}
		if(path == null) {
			bye(pad, false);
			return 0;
		}
		Directory dir = Directory(path);
		FileNode node = dir.iterator().get();
		etxt output = etxt.stack(128);
		output.concat(&node.fileName);
		output.concat_char('\n');
		pad.write(&output);
		bye(pad, true);
		return 0;
	}
}
/* @} */
