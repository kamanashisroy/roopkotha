using aroop;
using shotodol;
using roopkotha;

public class roopkotha.FontImpl : roopkotha.Font {
	internal FontPlatformImpl plat;
	public FontImpl() {
		plat = FontPlatformImpl();
	}
	
	public override int getHeight() {
		return plat.getHeight();
	}
	
	public override int subStringWidth(aroop.txt str, int offset, int width) {
		return plat.subStringWidth(str, offset, width);
	}
	
	~FontImpl() {
		plat.destroy();
	}
}
