using aroop;
using shotodol;
using shotodol_platform_fileutils;

/** \addtogroup gui_command
 *  @{
 */
internal class FileListCommand : M100QuietCommand {
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

	public override int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		SearchableSet<txt> vals = SearchableSet<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
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
			output.printf("<LI href=\"velafopen://%s\">%s</LI>", node.fileName.to_string(), node.fileName.to_string());
			pad.write(&output);
		}
		return 0;
	}
}
/* @} */
