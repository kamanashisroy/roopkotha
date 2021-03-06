using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup gui
 *  @{
 */
public class roopkotha.gui.BasicFont : roopkotha.gui.Font {
	uchar flaggedVariantInfo;
	uchar flaggedFaceInfo;
	public BasicFont.defined(uchar face, uchar vars) {
		flaggedFaceInfo = face;
		flaggedVariantInfo = vars;
	}

	public BasicFont.from(BasicFont src, Font.Variant stl) {
		flaggedVariantInfo = src.flaggedVariantInfo;
		flaggedVariantInfo |= stl;
	}
	
	public override int getHeight() {
		//return GUICore.getHeight(flaggedVariantInfo);
		return 10;
	}
	
	public override int subStringWidth(extring*str, int offset, int width) {
		//return GUICore.subStringWidth(flaggedVariantInfo, str, offset, width);
		return 5*str.length();
	}
	
	public override Font getVariant(Font.Variant stl) {
		return new BasicFont.from(this, stl);
	}

	public override int getId() {
		return ((flaggedFaceInfo << 8) | flaggedVariantInfo);
	}

	~BasicFont() {
	}

#if GUI_DEBUG
	public override void dumpAll(extring*buf) {
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
/** @} */
