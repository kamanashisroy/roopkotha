using aroop;
using shotodol;
using roopkotha;
using roopkotha.vela;

/** \addtogroup vela
 *  @{
 */
public class roopkotha.vela.VelaResource : Replicable {
	public enum Type {
		DOCUMENT,
		IMAGE,
	}
	public Type tp {public get;private set;}
	public VelaResource(etxt*base, etxt*aUrl, PageAppDocument referer, WebVariables?vars) {
		// TODO fill me
	}
}
public delegate void roopkotha.vela.ContentReadyCB(VelaResource id, Replicable content);
public delegate void roopkotha.vela.ContentErrorCB(VelaResource id, int code, etxt*reason);
public abstract class roopkotha.vela.VelaResourceLoader : Replicable {
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
