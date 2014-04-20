using aroop;
using shotodol;
using roopkotha;
using roopkotha.vela;

/** \addtogroup vela
 *  @{
 */
public class roopkotha.vela.WebResource : Replicable {
	public enum Type {
		DOCUMENT,
		IMAGE,
	}
	public Type tp {public get;private set;}
	public WebResource(etxt*base, etxt*aUrl, PageAppDocument referer, WebVariables?vars) {
		// TODO fill me
	}
}
public delegate void roopkotha.vela.ContentReadyCB(WebResource id, Replicable content);
public delegate void roopkotha.vela.ContentErrorCB(WebResource id, int code, etxt*reason);
public abstract class roopkotha.vela.WebResourceLoader : Replicable {
	ContentReadyCB?onContentReady;
	ContentErrorCB?onContentError;
	public WebResourceLoader() {
		onContentReady = null;
	}
	public abstract int request(WebResource id);
	public void setContentCallback(ContentReadyCB cb) {
		onContentReady = cb;
	}
	public void setContentErrorCallback(ContentErrorCB cb) {
		onContentError = cb;
	}
}
/** @} */
