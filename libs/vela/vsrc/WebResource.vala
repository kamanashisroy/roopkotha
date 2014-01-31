using aroop;
using shotodol;
using roopkotha;
using roopkotha.vela;

public abstract class roopkotha.vela.WebResource : Replicable {
	enum Type {
		DOCUMENT,
		IMAGE,
	}
	public WebResource(etxt*base, etxt*aUrl, PageAppDocument referer, WebVariables vars) {
		// TODO fill me
	}
}
public abstract class roopkotha.vela.WebResourceLoader : Replicable {
	public abstract int request(txt id);
}
