using aroop;
using shotodol;
using roopkotha;
using roopkotha.vela;

/** \addtogroup vela_malleable
 *  @{
 */
public abstract class roopkotha.vela_malleable.LocalResourceLoader : VelaResourceLoader {
	Hashtable<VelaResourceLoader> loaders;
	public LocalResourceLoader() {
		loaders = Hashtable<ValaResourceLoader>();
	}
	~LocalResourceLoader() {
		loaders.destroy();
	}
	VelaResourceLoader? getLoader(VelaResource id) {
		etxt prefix = etxt.same_same(id.base.is_empty()?&id.url:id.base);
		bool valid = false;
		int i = 0;
		int len = prefix.length();
		for(i = 0; i < len;i++) {
			if(prefix.char_at(i) != ':') {
				prefix.trim_to_length(i);
				valid = true;
				break;
			}
		}
		if(valid) {
			return loaders.get(&prefix);
		}
		return null;
	}
	public int request(VelaResource id) {
		VelaResourceLoader loader = getLoader(id);
		loader.load();
	}
}
/** @} */
