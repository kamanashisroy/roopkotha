using aroop;
using shotodol;
using roopkotha;

public class roopkotha.PlainContent : AugmentedContent {
	txt data;
	public PlainContent(etxt*asciiData) {
		base();
		data = new txt.memcopy_etxt(asciiData);
	}
	public override int getText(etxt*tData) {
		tData.concat(data);// = etxt.same_same(data);
		return 0;
	}
}
