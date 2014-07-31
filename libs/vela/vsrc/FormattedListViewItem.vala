using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.gui.listview;
using roopkotha.doc;
using roopkotha.vela;

/** \addtogroup vela
 *  @{
 */
public delegate onubodh.RawImage roopkotha.vela.MediaLoader(extring*src);
public class roopkotha.vela.FormattedListViewItem : ListViewItem {
	/**
	 * y-coordinate position of the image
	 */
	protected int xPos; // = 0
	protected int yPos;// = 0;

	protected int transX; // = 0
	protected int transY;// = 0;
	protected int lineHeight; // = 0;
	protected int width;
	protected bool selected;// = false;
	protected FormattedContent content;
	protected roopkotha.vela.MediaLoader loader;// = null;

	int minLineHeight = -1;// = Font.getFont(Font.FACE_SYSTEM, Font.STYLE_PLAIN,Font.SIZE_SMALL).getHeight()+display.PADDING;

	public FormattedListViewItem() {
		//memclean_raw();
	}

	public void factoryBuild(FormattedContent aContent) {
		xPos = yPos = 0;
		transX = transY = 0;
		lineHeight = 0;
		selected = false;
		loader = null;
		minLineHeight = -1;
		type = ListViewItem.itemtype.OTHER;
		content = aContent;
	}

	protected void clearLineFull(roopkotha.gui.Graphics g, int y, int height) {
		if (!selected)
			return;
		int oldColor = g.getColor();
		// #expand g->set_color(%net.ayaslive.miniim.ui.core.markup.bgHover%);
		g.setColor(0xCCCCCC);
		g.fillRect(xPos, y, width, height);
		g.setColor(oldColor);
	}

	protected void clearLine(roopkotha.gui.Graphics g) {
		if (!selected)
			return;
		clearLineFull(g, yPos, lineHeight);
	}

	protected void breakLine(roopkotha.gui.Graphics g) {
		// put a line break
		yPos += lineHeight;
		xPos = transX;

		// reset line height to minimum
		lineHeight = minLineHeight;

		core.assert(yPos != 0 && lineHeight != 0);
		// clear the next line
		clearLine(g);
	}

	protected void updateHeight(roopkotha.gui.Graphics g, int newHeight) {
		if (newHeight > lineHeight) {
			// fill with background color
			clearLineFull(g, yPos + lineHeight, newHeight - lineHeight);
		}
		lineHeight = newHeight;
		//print("Line height:%d\n", lineHeight);
	}

	protected void updateHeightForFont(roopkotha.gui.Graphics g, roopkotha.gui.Font font) {
		core.assert(font != null);
#if false
		if (font == null) {
			return;
		}
#endif
		int height = font.getHeight();
		if (lineHeight < (height + ListViewItem.display.PADDING)) {
			updateHeight(g, height + ListViewItem.display.PADDING);
		}
	}

	protected void renderImage(roopkotha.gui.Graphics g, FormattedTextCapsule*cap) {
	#if false
		xultb_str_t* src = elem->get_attribute_value(null, "src");
		if (src == null) {
			return;
		}
		Image img = loader.getImage(src);
		if (img == null) {
			return;
		}
		int imgWidth = img.getWidth();
		int imgHeight = img.getHeight();

		// so we can use it inline
		xultb_str_t* position = elem->get_attribute_value(null, "p");
		if (position != null) {
			breakLine();
			if (position.equals("c")) {
				position = null;
			}
			g.drawImage(img, (position == null) ? width / 2 : xPos, yPos,
					Graphics.TOP
							| ((position == null) ? Graphics.HCENTER
									: position.equals("l") ? Graphics.LEFT
											: Graphics.RIGHT));
			updateHeight(imgHeight + ListViewItem.display.PADDING);
			breakLine();
		} else {
			if (width - xPos < imgWidth) {
				breakLine();
			}
			g.drawImage(img, xPos, yPos, Graphics.TOP | Graphics.LEFT);

			// increase line height if the image height is larger ..
			imgHeight += ListViewItem.display.PADDING;
			updateHeight(imgHeight > lineHeight ? imgHeight : lineHeight);

			xPos += imgWidth;
			xPos += 4;/* finally add a space: 4px */
			if (width - xPos < 0) { /* pushed too much */
				breakLine();
			}
		}
	#endif
	}

	protected void renderText(roopkotha.gui.Graphics g, roopkotha.gui.Font font, extring*text) {
		int off, ret;
#if GUI_DEBUG
		extring talk = extring.stack(128);
		talk.printf("Rendering text:%s\n", text.to_string());
		font.dumpAll(&talk);
		talk.concat_char('\n');
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
	//	text = text.replace('\n', ' ').replace('\r', ' ').trim(); /*< skip the newlines */
		if (text.is_empty()) { /*< empty xultb_str_t* .. skip */
			return;
		}
		g.setFont(font);
		updateHeightForFont(g, font);

		off = 0;
		while ((ret = TextFormat.wrap_next(text, font, off, width - xPos)) != -1) {
			//extring subtext;
			// draw the texts ..
			if (ret > off) {
				// draw the line of text
				extring xt = extring.copy_shallow(text);
				xt.shift(off);
				xt.trim_to_length(ret);
				//print(">> ... * Drawing text(%d,%d):%s\n", xPos, yPos, xt.to_string());
				g.drawString(&xt, xPos, yPos, 1000, 1000, roopkotha.gui.Graphics.anchor.TOP | roopkotha.gui.Graphics.anchor.LEFT);
				xPos += font.subStringWidth(text, off, ret - off);
			}
			if (ret == off /* no place to write a word .. */
			|| ret < text.length() /* there are more words so that we span into new line .. */
			|| (width - xPos) < 0 /* pushed too much */
			) {
				breakLine(g);
			}
			off = ret;
		}

		if (xPos != 0) {
			xPos += 4;/* finally add a space: 4px */
			if (width - xPos < 0) { /* pushed too much */
				breakLine(g);
			}
		}
	}

	protected void renderFormattedText(roopkotha.gui.Graphics g, roopkotha.gui.Font font, FormattedTextCapsule*cap) {
		{
#if GUI_DEBUG
				extring talk = extring.stack(128);
				talk.printf("Rendering capsule: %d\n", cap.textType);
				Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
		}
		int oldColor = g.getColor();
		core.assert(font != null);
		roopkotha.gui.Font newFont = font;
		core.assert(newFont != null);

		if (cap.textType == FormattedTextType.BR) {
			breakLine(g);
		} else if (cap.textType == FormattedTextType.IMG) {
			renderImage(g, cap);
		} else if (cap.textType == FormattedTextType.B) {
			newFont = font.getVariant(Font.Variant.BOLD);
		} else if (cap.textType == FormattedTextType.I) {
			newFont = font.getVariant(Font.Variant.ITALIC);
		} else if (cap.textType == FormattedTextType.BIG) {
			newFont = font.getVariant(Font.Variant.LARGE);
		} else if (cap.textType == FormattedTextType.SMALL) {
			newFont = font.getVariant(Font.Variant.SMALL);
		} else if (cap.textType == FormattedTextType.STRONG || cap.textType == FormattedTextType.EM) {
			/// \xxx what to do for strong text ??
			newFont = font.getVariant(Font.Variant.BOLD | Font.Variant.MEDIUM);
		} else if (cap.textType == FormattedTextType.U) {
			newFont = font.getVariant(Font.Variant.UNDERLINED);
		} else if (cap.textType == FormattedTextType.P) {
			// line break
			breakLine(g);
			breakLine(g);
		} else if (cap.textType ==  FormattedTextType.A) {

			//xultb_str_t* link = xultb_ml_get_attribute_value(elem, "href");
			extring link = extring.copy_shallow(&cap.hyperLink);

			// draw the anchor
			if (link.is_empty()/* || !OPP_FACTORY_USE_COUNT(&elem->children)*/) {
				// skip empty links
			} else if (cap.isFocused) {
				// #expand g->set_color(%net.ayaslive.miniim.ui.core.markup.aFgHover%);
				g.setColor(0x0000FF);
				// #expand newFont = xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font) | %net.ayaslive.miniim.ui.core.markup.aFontHover%, xultb_font_get_size(font));
				newFont = font.getVariant(Font.Variant.UNDERLINED | Font.Variant.BOLD);
			} else if (cap.isActive) {
				// #expand g->set_color(%net.ayaslive.miniim.ui.core.markup.aFgActive%);
				g.setColor(0xCC99FF);

				// #expand newFont = xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font) | %net.ayaslive.miniim.ui.core.markup.aFontActive%, xultb_font_get_size(font));
				newFont = font.getVariant(Font.Variant.UNDERLINED);
			} else {
				// #expand g->set_color(%net.ayaslive.miniim.ui.core.markup.aFg%);
				g.setColor(0x0000FF);

				// #expand newFont = xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font) | %net.ayaslive.miniim.ui.core.markup.aFont%, xultb_font_get_size(font));
				newFont = font.getVariant(Font.Variant.UNDERLINED);
			}
		} else {
			// We do not know how to handle this element
			// SimpleLogger.debug(this, "renderNode()\t\tNothing to do for: " + tagName);
			// go on with inner elements
		}
		core.assert(newFont != null);
		// render the inner nodes
		content.traverseCapsules((child) => {
#if GUI_DEBUG
				extring talk = extring.stack(128);
				talk.printf("Rendering child of [%d]-", cap.textType);
				newFont.dumpAll(&talk);
				talk.concat_char('\n');
				Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
				if (child.textType == FormattedTextType.PLAIN) {
					core.assert(newFont != null);
					renderText(g, newFont, &child.content);
				} else {
					renderFormattedText(g, newFont, child);
				}
				return 0;
		});
		g.setColor(oldColor);
		{
#if GUI_DEBUG
				extring talk = extring.stack(128);
				talk.printf("End capsule: %d\n", cap.textType);
				Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
		}
	}

#if false
	int getActualCardHeight() {
		return yPos;
	}
#endif

	public override int paint(GUIInput input, roopkotha.gui.Graphics g, int x, int y, int aWidth, bool aSelected) {
		transX = x;
		transY = y;
		xPos = transX;
		yPos = transY;
		width = aWidth; 
		selected = aSelected;
		// #expand g->set_color(%net.ayaslive.miniim.ui.core.markup.fg%);
		g.setColor(0x006699);
		roopkotha.gui.Font font = new BasicFont.defined(roopkotha.gui.Font.Face.DEFAULT, roopkotha.gui.Font.Variant.PLAIN | roopkotha.gui.Font.Variant.SMALL);
		core.assert(font != null);
		if(minLineHeight == -1) {
			minLineHeight = font.getHeight()+ListViewItem.display.PADDING;
		}
		lineHeight = minLineHeight;
		//print("Line height:%d\n", lineHeight);
		//	g.translate(x, y);

		// draw the line background
		clearLine(g);

		content.traverseCapsulesInit();
		// draw the node recursively
		content.traverseCapsules((cap) => {
#if GUI_DEBUG
			extring talk = extring.stack(128);
			talk.printf("Rendering[Paint] ..");
			font.dumpAll(&talk);
			talk.concat_char('\n');
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &talk);
#endif
			if (cap.textType == FormattedTextType.PLAIN) {
				renderText(g, font, &cap.content);
			} else {
				renderFormattedText(g, font, cap);
			}
			return 0;
		});


		int ret = yPos;
		if (xPos != 0) {
			ret = yPos + lineHeight;
		}

		// fix the position and font
		//g->translate(-x, -y);
		//g->set_font(ITEM_FONT);
		return ret;
	}

	public override bool doEdit(int flags, int key_code, int x, int y) {
		// TODO fill me
		return false;
	}

	public override int update(extring*xt) {
		// TODO fill me 
		return 0;
	}
}
/** @} */
