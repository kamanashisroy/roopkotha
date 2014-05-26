using aroop;
using shotodol;
using shotodol_platform_fileutils;

/** \addtogroup gui_command
 *  @{
 */
internal class FileListCommand : M100Command {
	etxt prfx;
	enum Options {
		PATH = 1,
	}
	public FileListCommand() {
		base();
		etxt path = etxt.from_static("-p");
		etxt path_help = etxt.from_static("Path");
		addOption(&path, M100Command.OptionType.TXT, Options.PATH, &path_help);
	}
	
	public override etxt*get_prefix() {
		prfx = etxt.from_static("ls");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad) {
		SearchableSet<txt> vals = SearchableSet<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			desc(CommandDescType.COMMAND_DESC_FULL, pad);
			return 0;
		}
		unowned txt?path = null;
		etxt currentPath = etxt.from_static(".");
		container<txt>? mod = null;
		mod = vals.search(Options.PATH, match_all);
		if(mod != null) {
			path = mod.get();
		}
		Directory dir = Directory(path == null?&currentPath:path);
		FileNode?node = null;
		etxt output = etxt.stack(512);
		while((node = dir.iterator().get()) != null) {
			output.printf("<div href=\"velafopen://%s\">%s</div>", node.fileName.to_string(), node.fileName.to_string());
			pad.write(&output);
		}
		return 0;
	}
}
/* @} */
