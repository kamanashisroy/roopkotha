using aroop;
using shotodol;
using roopkotha;
using roopkotha.vela;

/** \addtogroup velagent
 *  @{
 */
public class roopkotha.velagent.CompoundResourceHandler : VelaResourceHandler {
	HashTable<VelaResourceHandler?> loaders;
	public CompoundResourceHandler() {
		loaders = HashTable<VelaResourceHandler?>();
	}
	~CompoundResourceHandler() {
		loaders.destroy();
	}
	VelaResourceHandler? getHandler(VelaResource id) {
		etxt prefix = etxt.stack(64);
		id.copyPrefix(&prefix);
		if(prefix.is_empty()) {
			return null;
		}
		return loaders.get(&prefix);
	}
	public override int request(VelaResource id) {
		VelaResourceHandler?loader = getHandler(id);
		if(loader == null) {
			return -1;
		}
		return loader.request(id);
	}
}
/** @} */
