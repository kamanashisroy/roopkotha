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
		extring prefix = extring.stack(64);
		id.copyPrefix(&prefix);
		if(prefix.is_empty()) {
			extring dlg = extring.stack(128);
			dlg.printf("Handler is empty:%s\n", id.url.to_string());
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 1, Watchdog.WatchdogSeverity.ALERT, 0, 0, &dlg);
			return null;
		}
		return handlers.get(&prefix);
	}
	public void setHandler(xtring prefix, VelaResourceHandler?hdlr) {
		if(hdlr != null) {
			hdlr.setContentCallback(onContentReady);
			hdlr.setContentErrorCallback(onContentError);
		}
		handlers.set(prefix, hdlr);
	}
	public override int request(VelaResource id) {
		VelaResourceHandler?handler = getHandler(id);
		if(handler == null) {
			onContentError(id, 0, null);
			return -1;
		}
		return handler.request(id);
	}
}
/** @} */
