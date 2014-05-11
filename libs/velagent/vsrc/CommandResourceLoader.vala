using aroop;
using shotodol;
using roopkotha;
using roopkotha.vela;

/** \addtogroup velagent;
 *  @{
 */
public class roopkotha.velagent.CommandResourceLoader : VelaResourceLoader {
	M100CommandSet velamds;
	BufferedOutputStream bout;
	CommandResourceLoader.common() {
		bout = new BufferedOutputStream(1024);
	}
	public CommandResourceLoader() {
		velamds = new M100CommandSet();
		CommandResourceLoader.common();
	}
	public CommandResourceLoader.givenCommandSet(M100CommandSet cmds) {
		velamds = cmds;
		CommandResourceLoader.common();
	}
	~CommandResourceLoader() {
	}
	public override int request(VelaResource id) {
		etxt prefix = etxt.stack(64);
		id.copyPrefix(&prefix);
		int len = prefix.length();
		print("prefix[%d]:%s\n", len, prefix.to_string());
		etxt cmdTxt = etxt.same_same(&id.url);
		cmdTxt.shift(len+3);
		bout.reset();
		velamds.act_on(&cmdTxt, bout);
		etxt content = etxt.EMPTY();
		bout.getAs(&content);
		print("[%s]\n", content.to_string());
		txt ctxt = new txt.memcopy_etxt(&content); // TODO reduce this memcopy
		onContentReady(id, ctxt);
		content.destroy();
		return 0;
	}
}
/** @} */
