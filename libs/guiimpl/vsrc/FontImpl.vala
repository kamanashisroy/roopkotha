using aroop;
using shotodol;
using roopkotha;

public class roopkotha.FontImpl : roopkotha.Font {
	internal FontPlatformImpl plat;
	public FontImpl() {
		plat = FontPlatformImpl.create();
	}

	public FontImpl.from(FontImpl src, Font.Variant stl) {
		plat = src.plat.getVariant(stl);
	}
	
	public override int getHeight() {
		return plat.getHeight();
	}
	
	public override int subStringWidth(etxt*str, int offset, int width) {
		return plat.subStringWidth(str, offset, width);
	}
	
	public override Font getVariant(Font.Variant stl) {
		return new FontImpl.from(this, stl);
	}

	~FontImpl() {
	}
}
