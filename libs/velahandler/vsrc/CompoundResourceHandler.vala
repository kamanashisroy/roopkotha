using aroop;
using shotodol;
using roopkotha.velagent;

/** \addtogroup velahandler
 *  @{
 */
public class roopkotha.velahandler.CompoundResourceHandler : VelaResourceHandler {
	HashTable<VelaResourceHandler?> handlers;
	public CompoundResourceHandler() {
		handlers = HashTable<VelaResourceHandler?>();
	}
	~CompoundResourceHandler() {
		handlers.destroy();
	}
	VelaResourceHandler? getHandler(VelaResource id) {
		etxt prefix = etxt.stack(64);
		id.copyPrefix(&prefix);
		if(prefix.is_empty()) {
			return null;
		}
		return handlers.get(&prefix);
	}
	public void setHandler(txt prefix, VelaResourceHandler?hdlr) {
		if(hdlr != null) {
			hdlr.setContentCallback(onContentReady);
			hdlr.setContentErrorCallback(onContentError);
		}
		handlers.set(prefix, hdlr);
	}
	public override int request(VelaResource id) {
		VelaResourceHandler?handler = getHandler(id);
		if(handler == null) {
			return -1;
		}
		return handler.request(id);
	}
}
/** @} */
