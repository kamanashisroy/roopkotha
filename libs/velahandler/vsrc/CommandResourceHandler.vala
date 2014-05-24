using aroop;
using shotodol;
using roopkotha.velagent;
using roopkotha.velatml;

/** \addtogroup velahandler;
 *  @{
 */
public class roopkotha.velahandler.CommandResourceHandler : VelaResourceHandler {
	M100CommandSet velamds;
	BufferedOutputStream bout;
	CommandResourceHandler.common() {
		bout = new BufferedOutputStream(1024);
	}
	public CommandResourceHandler() {
		velamds = new M100CommandSet();
		CommandResourceHandler.common();
	}
	public CommandResourceHandler.givenCommandSet(M100CommandSet cmds) {
		velamds = cmds;
		CommandResourceHandler.common();
	}
	~CommandResourceHandler() {
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
	
		VTMLDocument pd = new VTMLDocument();
		pd.spellChunk(ctxt);
		onContentReady(id, pd);

		content.destroy();
		return 0;
	}
}
/** @} */
