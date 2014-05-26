using aroop;
using shotodol;
using roopkotha.velagent;

/** \addtogroup velahandler
 *  @{
 */
public class roopkotha.filecommands.DefaultFileResourceHandler : FileResourceHandler {
	public DefaultFileResourceHandler() {
	}

	public void setHandlers() {
		txt suffix = new txt.from_static(".vapp");
		setHandler(suffix, new VelaAppFileResourceHandler());
	}
}
/** @} */
