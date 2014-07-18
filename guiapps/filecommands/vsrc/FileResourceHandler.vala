using aroop;
using shotodol;
using roopkotha.velagent;

/** \addtogroup velahandler
 *  @{
 */
public class roopkotha.filecommands.FileResourceHandler : VelaResourceHandler {
	HashTable<VelaResourceHandler?> handlers;
	public FileResourceHandler() {
		handlers = HashTable<VelaResourceHandler?>();
	}
	~FileResourceHandler() {
		handlers.destroy();
	}
	VelaResourceHandler? getHandler(VelaResource id) {
		int len = id.url.length();
		int i = 0;
		extring fileext = extring();
		for(i = len; i > 0; i--) {
			if(id.url.char_at(i) == '.') {
				fileext = extring.copy_shallow(&id.url);
				fileext.shift(i);
			}
		}
		if(fileext.is_empty()) {
			// TODO use plain opener
			return null;
		}
		return handlers.get(&fileext);
	}
	public void setHandler(xtring fileext, VelaResourceHandler hdlr) {
		hdlr.setContentCallback(onContentReady);
		hdlr.setContentErrorCallback(onContentError);
		handlers.set(fileext, hdlr);
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
