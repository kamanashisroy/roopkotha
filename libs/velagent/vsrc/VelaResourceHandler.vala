using aroop;
using shotodol;
using roopkotha;
using roopkotha.vela;
using roopkotha.doc;

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
	RoopDocument referer;
	public VelaResource(etxt*gBase, etxt*gUrl, RoopDocument gReferer) {
		if(gBase.is_empty_magical()) {
			baseUrl = etxt.EMPTY();
		} else {
			baseUrl = etxt.dup_etxt(gBase);
		}
		if(gUrl.is_empty_magical()) {
			url = etxt.EMPTY();
		} else {
			url = etxt.dup_etxt(gUrl);
		}
		tp = Type.DOCUMENT;
		//print("x:%s-%s\n", baseUrl.to_string(), url.to_string());
		referer = gReferer;
	}
	public void copyPrefix(etxt*prefix) {
		//etxt*x = baseUrl.is_empty_magical()?&url:&baseUrl;
		//print("x:%s\n", x.to_string());
		prefix.concat(&baseUrl);
		prefix.concat(&url);
		bool valid = false;
		int i = 0;
		int len = prefix.length();
		for(i = 0; i < len;i++) {
			if(prefix.char_at(i) == ':') {
				prefix.trim_to_length(i);
				//print("Prefix:%s\n", prefix.to_string());
				valid = true;
				break;
			}
		}
		if(!valid && len != 0) {
			prefix.trim_to_length(0);
		}
	}

}
public delegate void roopkotha.velagent.ContentReadyCB(VelaResource id, Replicable content);
public delegate void roopkotha.velagent.ContentErrorCB(VelaResource id, int code, etxt*reason);
public abstract class roopkotha.velagent.VelaResourceHandler : Replicable {
	protected ContentReadyCB?onContentReady;
	protected ContentErrorCB?onContentError;
	public VelaResourceHandler() {
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
