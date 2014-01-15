using aroop;
using shotodol;
using roopkotha;

public class roopkotha.FormattedListItem : ListViewItem {
	/**
	 * y-coordinate position of the image
	 */
	protected int xPos; // = 0
	protected int yPos;// = 0;

	protected int lineHeight; // = 0;
	protected int width;
	protected bool selected;// = false;
	protected FormattedContent content;
	struct xultb_media_loader*loader;// = null;

	static int minLineHeight = 0;// = Font.getFont(Font.FACE_SYSTEM, Font.STYLE_PLAIN,Font.SIZE_SMALL).getHeight()+PADDING;

	protected void factoryBuild(FormattedContent aContent) {
		xPos = yPos = 0;
		lineHeight = 0;
		selected = false;
		loader = null;
		Font = xultb_font_get(XULTB_FONT_FACE_SYSTEM, XULTB_FONT_STYLE_PLAIN, XULTB_FONT_SIZE_SMALL);
		minLineHeight = font.getHeight()+PADDING;
		content = aContent;
		target = content;
	}

	protected void clearLineFull(roopkotha.Graphics g, int y, int height) {
		if (!selected)
			return;
		int oldColor = g.getColor();
		// #expand g->set_color(%net.ayaslive.miniim.ui.core.markup.bgHover%);
		g.setColor(0xCCCCCC);
		g.fillRect(0, y, width, height);
		g.setColor(oldColor);
	}

	protected void clearLine(roopkotha.Graphics g) {
		if (!selected)
			return;
		clearLineFull(g, yPos, lineHeight);
	}

	protected void breakLine(roopkotha.Graphics g) {
		// put a line break
		yPos += lineHeight;
		xPos = 0;

		// reset line height to minimum
		lineHeight = minLineHeight;

		// clear the next line
		clearLine(g);
	}

	protected void updateHeight(roopkotha.Graphics g, int newHeight) {
		if (newHeight > lineHeight) {
			// fill with background color
			clearLineFull(g, yPos + lineHeight, newHeight - lineHeight);
		}
		lineHeight = newHeight;
	}

	protected void updateHeightForFont(roopkotha.Graphics g, roopkotha.Font font) {
		if (!font) {
			return;
		}
		const int height = font.getHeight(font);
		if (lineHeight < (height + XULTB_LIST_ITEM_PADDING)) {
			updateHeight(g, height + XULTB_LIST_ITEM_PADDING);
		}
	}

	static void renderImage(roopkotha.Graphics g, FormattedTextCapsule*cap) {
	#if 0
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
			updateHeight(imgHeight + XULTB_LIST_ITEM_PADDING);
			breakLine();
		} else {
			if (width - xPos < imgWidth) {
				breakLine();
			}
			g.drawImage(img, xPos, yPos, Graphics.TOP | Graphics.LEFT);

			// increase line height if the image height is larger ..
			imgHeight += XULTB_LIST_ITEM_PADDING;
			updateHeight(imgHeight > lineHeight ? imgHeight : lineHeight);

			xPos += imgWidth;
			xPos += 4;/* finally add a space: 4px */
			if (width - xPos < 0) { /* pushed too much */
				breakLine();
			}
		}
	#endif
	}

	protected void renderText(roopkotha.Graphics g, roopkotha.Font font, txt text) {
		int off, ret;
	//	text = text.replace('\n', ' ').replace('\r', ' ').trim(); /*< skip the newlines */
		if (text.isEmpty()) { /*< empty xultb_str_t* .. skip */
			return;
		}
		g.setFont(font);
		updateHeightForFont(g, font);

		off = 0;
		while ((ret = TextFormat.wrap_next(text, font, off, width - xPos)) != -1) {
			xultb_str_t subtext;
			// draw the texts ..
			if (ret > off) {
				// draw the line of text
				etxt xt = etxt.same_same(text);
				xt.shift(off);
				xt.trim_to_length(ret);
				g.drawString(&xt, xPos, yPos, 1000, 1000, XULTB_GRAPHICS_TOP | XULTB_GRAPHICS_LEFT);
				xPos += font.substringWidth(text, off, ret - off);
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

	protected void renderFormattedText(roopkotha.Graphics g, FormattedTextCapsule*cap, roopkotha.Font font) {
		int oldColor = g.getColor();
		roopkotha.Font newFont = font;

		if (cap.textType == FormattedTextCapsule.FormattedTextType.BR) {
			breakLine(g);
		} else if (cap.textType == FormattedTextCapsule.FormattedTextType.IMG) {
			renderImage(g, cap);
		} else if (cap.textType == FormattedTextCapsule.FormattedTextType.B) {
			newFont = font.getVariant(Font.Variant.BOLD);
		} else if (cap.textType == FormattedTextCapsule.FormattedTextType.I) {
			newFont = font.getVariant(Font.Variant.ITALIC);
		} else if (cap.textType == FormattedTextCapsule.FormattedTextType.BIG) {
			newFont = font.getVariant(Font.Variant.LARGE);
		} else if (cap.textType == FormattedTextCapsule.FormattedTextType.SMALL) {
			newFont = font.getVariant(Font.Variant.SMALL);
		} else if (cap.textType == FormattedTextCapsule.FormattedTextType.STRONG || cap.textType == FormattedTextCapsule.FormattedTextType.EM) {
			/// \xxx what to do for strong text ??
			newFont = font.getVariant(Font.Variant.BOLD | Font.Variant.MEDIUM);
		} else if (cap.textType == FormattedTextCapsule.FormattedTextType.U) {
			newFont = font.getVariant(Font.Variant.UNDERLINED);
		} else if (cap.textType == FormattedTextCapsule.FormattedTextType.P) {
			// line break
			breakLine(g);
			breakLine(g);
		} else if (cap.textType ==  FormattedTextCapsule.FormattedTextType.A) {

			xultb_str_t* link = xultb_ml_get_attribute_value(elem, "href");

			// draw the anchor
			if (!OPP_FACTORY_USE_COUNT(&elem->children) || !link) {
				// skip empty links
			} else if (isFocused(elem)) {
				// #expand g->set_color(%net.ayaslive.miniim.ui.core.markup.aFgHover%);
				g.setColor(0x0000FF);
				// #expand newFont = xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font) | %net.ayaslive.miniim.ui.core.markup.aFontHover%, xultb_font_get_size(font));
				newFont = font.getVariant(Font.Variant.UNDERLINED | Font.Variant.BOLD);
			} else if (is_active(elem)) {
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
		// render the inner nodes
		// System.out.println("<"+tagName+">");
	//	int count = OPP_FACTORY_USE_COUNT(elem->children);//elem->getChildCount(elem);
		int i;
		for (i = 0;; i++) {
			struct xultb_ml_elem*obj;
			opp_at_ncode(obj, &elem->children, i,
				switch (obj->type) {
				case XULTB_ELEMENT_TEXT:
					renderText(item, g, newFont, obj->content);
					break;
				case XULTB_ELEMENT_NODE:
					renderFormattedText(item, g, newFont, (struct xultb_ml_node*) obj);
					break;
				default:
					SYNC_LOG(SYNC_VERB, "Nothing to do for %s\n", obj->content->str);
					break;
				}
			) else {
				break;
			}
		}
		// System.out.println("</"+tagName+">");
		g.setColor(oldColor);
	}

#if false
	int getActualCardHeight() {
		return yPos;
	}
#endif

	public override int paint(roopkotha.Window parent, roopkotha.Graphics g, int x, int y, int aWidth, bool aSelected) {
		xPos = 0;
		yPos = 0;
		width = aWidth; 
		selected = aSelected;
		// #expand g->set_color(%net.ayaslive.miniim.ui.core.markup.fg%);
		g.setColor(0x006699);
		lineHeight = minLineHeight;
		//	g.translate(x, y);

		// draw the line background
		clearLine(g);

		roopkotha.Font*font = parent.getFont(roopkotha.Font.Default, roopkotha.Font.PLAIN | roopkotha.Font.SMALL);
		// draw the node recursively
		renderFormattedText(g, font);


		int ret = yPos;
		if (xPos != 0) {
			ret = yPos + lineHeight;
		}

		// fix the position and font
		//g->translate(-x, -y);
		//g->set_font(ITEM_FONT);
		return ret;
	}
}
