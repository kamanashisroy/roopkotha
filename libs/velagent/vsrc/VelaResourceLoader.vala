using aroop;
using shotodol;
using roopkotha;
using roopkotha.vela;

/** \addtogroup velagent
 *  @{
 */
public class roopkotha.velagent.VelaResource : Replicable {
	public enum Type {
		DOCUMENT,
		IMAGE,
	}
	public Type tp {public get;private set;}
	public etxt baseUrl;
	public etxt url;
	public VelaResource(etxt*gBase, etxt*gUrl, PageAppDocument referer, WebVariables?vars) {
		// TODO fill me
	}
	public void getPrefix(etxt*prefix) {
		etxt*x = baseUrl.is_empty()?&url:&baseUrl;
		prefix.concat(x);
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
		if(!valid) {
			prefix.trim_to_length(0);
		}
	}

}
public delegate void roopkotha.velagent.ContentReadyCB(VelaResource id, Replicable content);
public delegate void roopkotha.velagent.ContentErrorCB(VelaResource id, int code, etxt*reason);
public abstract class roopkotha.velagent.VelaResourceLoader : Replicable {
	ContentReadyCB?onContentReady;
	ContentErrorCB?onContentError;
	public VelaResourceLoader() {
		onContentReady = null;
	}
	public abstract int request(VelaResource id);
	public void setContentCallback(ContentReadyCB cb) {
		onContentReady = cb;
	}
	public void setContentErrorCallback(ContentErrorCB cb) {
		onContentError = cb;
	}
}
/** @} */
