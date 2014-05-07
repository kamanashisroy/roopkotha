using aroop;
using shotodol;
using roopkotha;
using roopkotha.vela;

/** \addtogroup velagent
 *  @{
 */
public class roopkotha.velagent.CompoundResourceLoader : VelaResourceLoader {
	HashTable<VelaResourceLoader?> loaders;
	public CompoundResourceLoader() {
		loaders = HashTable<VelaResourceLoader?>();
	}
	~CompoundResourceLoader() {
		loaders.destroy();
	}
	VelaResourceLoader? getLoader(VelaResource id) {
		etxt prefix = etxt.stack(64);
		id.copyPrefix(&prefix);
		if(prefix.is_empty()) {
			return null;
		}
		return loaders.get(&prefix);
	}
	public override int request(VelaResource id) {
		VelaResourceLoader?loader = getLoader(id);
		if(loader == null) {
			return -1;
		}
		return loader.request(id);
	}
}
/** @} */
