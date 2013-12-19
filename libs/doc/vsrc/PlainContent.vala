using aroop;
using shotodol;
using roopkotha;

public class roopkotha.PlainContent : AugmentedContent {
	txt data;
	public PlainContent(etxt*asciiData) {
		base();
		data = new txt.memcopy_etxt(asciiData);
		_cType = ContentType.PLAIN_CONTENT;
		print("PlainContent:%s\n", data.to_string());
	}
	public override int getText(etxt*tData) {
		tData.concat(data);
		return 0;
	}
}
