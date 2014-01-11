using aroop;
using shotodol;
using roopkotha;

public class roopkotha.ValaAppContent : AugmentedContent {
	txt data;
	public ValaAppContent(etxt*asciiData) {
		base();
		data = new txt.memcopy_etxt(asciiData);
		cType = ContentType.PLAIN_CONTENT;
		print("PlainContent:%s\n", data.to_string());
	}
	public override int getText(etxt*tData) {
		tData.concat(data);
		return 0;
	}
}
