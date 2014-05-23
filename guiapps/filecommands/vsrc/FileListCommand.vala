using aroop;
using shotodol;
using shotodol_platform_fileutils;

/** \addtogroup gui_command
 *  @{
 */
internal class FileListCommand : M100Command {
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
		bool gui = /*false*/true;
		SearchableSet<txt> vals = SearchableSet<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			desc(CommandDescType.COMMAND_DESC_FULL, pad);
			if(!gui)
				bye(pad, false);
			return 0;
		}
		unowned txt?path = null;
		etxt currentPath = etxt.from_static(".");
		container<txt>? mod = vals.search(Options.GUI, match_all);
		if(mod != null) {
			gui = true;
		}
		mod = vals.search(Options.PATH, match_all);
		if(mod != null) {
			path = mod.get();
		}
		if(!gui)
			greet(pad);
		Directory dir = Directory(path == null?&currentPath:path);
		FileNode?node = null;
		etxt output = etxt.stack(512);
		while((node = dir.iterator().get()) != null) {
			output.trim_to_length(0);
			if(gui)
				output.concat_string("<SMALL>");
			output.concat(&node.fileName);
			if(gui)
				output.concat_string("</SMALL><BR></BR>");
			else
				output.concat_string("\n");
			pad.write(&output);
		}
		if(!gui)
			bye(pad, true);
		return 0;
	}
}
/* @} */
