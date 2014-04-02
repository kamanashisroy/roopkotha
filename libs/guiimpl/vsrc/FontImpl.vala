using aroop;
using shotodol;
using roopkotha;

public class roopkotha.FontImpl : roopkotha.Font {
	internal FontPlatformImpl plat;
	protected int flaggedVariantInfo;
	public FontImpl() {
		plat = FontPlatformImpl.create();
		flaggedVariantInfo = Font.Variant.PLAIN;
	}

	public FontImpl.from(FontImpl src, Font.Variant stl) {
		flaggedVariantInfo = src.flaggedVariantInfo;
		plat = src.plat.getVariant(stl);
		flaggedVariantInfo |= stl;
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

#if GUI_DEBUG
	public override void dumpAll(etxt*buf) {
		buf.concat_string("Font(");
		if((flaggedVariantInfo & Font.Variant.UNDERLINED) != 0) {
			buf.concat_string(" Underlined ");
		}
		if((flaggedVariantInfo & Font.Variant.BOLD) != 0) {
			buf.concat_string(" Bold ");
		}
		if((flaggedVariantInfo & Font.Variant.ITALIC) != 0) {
			buf.concat_string(" Italic ");
		}
		if((flaggedVariantInfo & Font.Variant.PLAIN) != 0) {
			buf.concat_string(" Plain ");
		}
		if((flaggedVariantInfo & Font.Variant.SMALL) != 0) {
			buf.concat_string(" Small ");
		}
		if((flaggedVariantInfo & Font.Variant.MEDIUM) != 0) {
			buf.concat_string(" Medium ");
		}
		if((flaggedVariantInfo & Font.Variant.LARGE) != 0) {
			buf.concat_string(" Large ");
		}
		buf.concat_string(")\n");
	}
#endif
}
