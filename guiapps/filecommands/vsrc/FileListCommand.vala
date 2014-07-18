using aroop;
using shotodol;
using shotodol_platform_fileutils;

/** \addtogroup gui_command
 *  @{
 */
internal class FileListCommand : M100QuietCommand {
	enum Options {
		PATH = 1,
	}
	public FileListCommand() {
		extring prefix = extring.set_static_string("ls");
		base(&prefix);
		addOptionString("-p", M100Command.OptionType.TXT, Options.PATH, "Path");
	}
	
	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?path = vals[Options.PATH];
		extring currentPath = extring.set_static_string(".");
		Directory dir = Directory(path == null?&currentPath:path);
		FileNode?node = null;
		extring output = extring.stack(512);
		while((node = dir.iterator().get()) != null) {
			output.printf("<LI href=\"velafopen://%s\">%s</LI>", node.fileName.to_string(), node.fileName.to_string());
			pad.write(&output);
		}
		return 0;
	}
}
/* @} */
