

public abstract roopkotha.WebResource : Replicable {
	enum Type {
		DOCUMENT,
		IMAGE,
	}
}
public abstract roopkotha.WebResourceLoader : Replicable {
	public abstract int request(txt id);
}
