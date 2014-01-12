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
struct xultb_media_loader*loader;// = null;

static int minLineHeight = 0;// = Font.getFont(Font.FACE_SYSTEM, Font.STYLE_PLAIN,Font.SIZE_SMALL).getHeight()+PADDING;
protected void factoryBuild() {
	xPos = yPos = 0;
	lineHeight = 0;
	selected = false;
	loader = null;
	Font = xultb_font_get(XULTB_FONT_FACE_SYSTEM, XULTB_FONT_STYLE_PLAIN, XULTB_FONT_SIZE_SMALL);
	minLineHeight = font.getHeight()+PADDING;
}

protected void clearLineFull(roopkotha.Graphics g, int y, int height) {
	if (!selected)
		return;
	int oldColor = g.getColor();
	// #expand g->set_color(%net.ayaslive.miniim.ui.core.markup.bgHover%);
	g.setColor(g, 0xCCCCCC);
	g.fillRect(g, 0, y, width, height);
	g.setColor(g, oldColor);
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

static void renderImage(struct xultb_markup_item*item, struct xultb_ml_node*elem) {
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
	g.setFont(g, font);
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
	xultb_str_t* tagName = elem->vtable->get_name(elem); /* Element name */
	struct xultb_font*newFont = font;
	int oldColor = g->get_color(g);
	SYNC_ASSERT(tagName->len != 0);

	if (xultb_str_equals_static(tagName, "br")) {
		breakLine(item, g);
	} else if (xultb_str_equals_static(tagName, "img")) {
		renderImage(item, elem);
	} else if (xultb_str_equals_static(tagName, "b")) {
		newFont = xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font)
				| XULTB_FONT_STYLE_BOLD, xultb_font_get_size(font));
	} else if (xultb_str_equals_static(tagName, "i")) {
		newFont = xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font)
				| XULTB_FONT_STYLE_ITALIC, xultb_font_get_size(font));
	} else if (xultb_str_equals_static(tagName, "big")) {
		newFont
				= xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font), XULTB_FONT_SIZE_LARGE);
	} else if (xultb_str_equals_static(tagName, "small")) {
		newFont
				= xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font), XULTB_FONT_SIZE_SMALL);
	} else if (xultb_str_equals_static(tagName, "strong") || xultb_str_equals_static(tagName, "em")) {
		/// \xxx what to do for strong text ??
		newFont = xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font)
				| XULTB_FONT_STYLE_BOLD, XULTB_FONT_SIZE_MEDIUM);
	} else if (xultb_str_equals_static(tagName, "u")) {
		newFont = xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font)
				| XULTB_FONT_STYLE_UNDERLINED, xultb_font_get_size(font));
	} else if (xultb_str_equals_static(tagName, "p")) {
		// line break
		breakLine(item, g);
		breakLine(item, g);
	} else if (xultb_str_equals_static(tagName, "a")) {

		xultb_str_t* link = xultb_ml_get_attribute_value(elem, "href");

		// draw the anchor
		if (!OPP_FACTORY_USE_COUNT(&elem->children) || !link) {
			// skip empty links
		} else if (isFocused(elem)) {
			// #expand g->set_color(%net.ayaslive.miniim.ui.core.markup.aFgHover%);
			g->set_color(g, 0x0000FF);
			// #expand newFont = xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font) | %net.ayaslive.miniim.ui.core.markup.aFontHover%, xultb_font_get_size(font));
			newFont = xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font)
					| XULTB_FONT_STYLE_UNDERLINED | XULTB_FONT_STYLE_BOLD, xultb_font_get_size(font));
			// SimpleLogger.debug(this, "renderNode()\t\tFocused:" + elem->getChild(0));
		} else if (is_active(elem)) {
			// #expand g->set_color(%net.ayaslive.miniim.ui.core.markup.aFgActive%);
			g->set_color(g, 0xCC99FF);

			// #expand newFont = xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font) | %net.ayaslive.miniim.ui.core.markup.aFontActive%, xultb_font_get_size(font));
			newFont = xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font)
					| XULTB_FONT_STYLE_UNDERLINED, xultb_font_get_size(font));
			// SimpleLogger.debug(this, "renderNode()\t\tActive:" + elem->getChild(0));
		} else {
			// #expand g->set_color(%net.ayaslive.miniim.ui.core.markup.aFg%);
			g->set_color(g, 0x0000FF);

			// #expand newFont = xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font) | %net.ayaslive.miniim.ui.core.markup.aFont%, xultb_font_get_size(font));
			newFont = xultb_font_get(xultb_font_get_face(font), xultb_font_get_style(font)
					| XULTB_FONT_STYLE_UNDERLINED, xultb_font_get_size(font));
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
	g->set_color(g, oldColor);
}

static int getActualCardHeight(struct xultb_markup_item*item) {
	return item->yPos;
}

/** List item implementation .. */
/*@{*/
public override int paint(roopkotha.Window parent, roopkotha.Graphics g, int x, int y, int width, bool selected) {
	xPos = 0;
	yPos = 0;
	width = width;
//	item->is_selected = is_selected;
	// #expand g->set_color(%net.ayaslive.miniim.ui.core.markup.fg%);
	g.setColor(g, 0x006699);
	lineHeight = minLineHeight;
//	g.translate(x, y);

	// draw the line background
	clearLine(g);

	Font*font = xultb_font_get(XULTB_FONT_FACE_DEFAULT, XULTB_FONT_STYLE_PLAIN, XULTB_FONT_SIZE_SMALL);
	// draw the node recursively
	renderFormattedText(g, font, (struct xultb_ml_node*)item->super_data.target);


	int ret = yPos;
	if (xPos != 0) {
		ret = yPos + lineHeight;
	}

	// fix the position and font
//	g->translate(-x, -y);
//	g->set_font(ITEM_FONT);
	return ret;
}
static struct xultb_list_item*xultb_page_get_item_helper(struct xultb_list*list, void*data) {
	struct xultb_page*mlist = (struct xultb_page*)list;
	struct xultb_ml_node*elem = (struct xultb_ml_node*)data;
	xultb_str_t*name = elem->vtable->get_name(elem);
	xultb_str_t*label = xultb_ml_get_attribute_value(elem, "l");
	if (!name || xultb_str_equals_static(name, "m")) {
		return (struct xultb_list_item*)xultb_markup_item_create(elem, mlist->ml, XULTB_FALSE, mlist->el);
	} else if (xultb_str_equals_static(name, "l")) {
		xultb_str_t*text = DOT;
#if 0
		if (OPP_FACTORY_USE_COUNT(&elem->children)) {
			void*obj;
			opp_at_ncode(obj, &elem->children, 0,
				text = ((struct xultb_ml_elem*)obj)->content;
				if (text) {
					text = xultb_str_trim(text);
				} else {
					text = DOT;
				}
			);
		}
#else
		text = xultb_ml_get_text(elem);
		text = xultb_str_trim(text);
#endif

		// see if the label has any image
		struct xultb_img*img = NULL;
		xultb_str_t*src = xultb_ml_get_attribute_value(elem, "src");
		if (src) {
			img = mlist->ml->get_image(src);
		}
		return xultb_list_item_create_label_full(text, img, xultb_ml_get_attribute_value(elem,
				"href") != NULL, XULTB_FALSE, elem);
	} else if (xultb_str_equals_static(name, "t")) {

		// get current text
		xultb_str_t*text = BLANK_STRING;
		if (/*!OPP_FACTORY_USE_COUNT(&elem->children) || */!(text = xultb_ml_get_text(elem))) {

			// get hint of this field
			text = xultb_ml_get_attribute_value(elem, "h");
			if (!text) {
				text = BLANK_STRING;
			}
		} else {
			// get rid of spaces
			text = xultb_str_trim(text);
		}

		// see if it is password field
		if (xultb_list_item_attr_is_positive(elem, "p")) {

			// in this case we hide the content of the password ..
			text = xultb_str_clone(ASTERISKS_STRING->str, text->len, 0);
		}

		// do not scroll continuously when there is textfield
		mlist->continuousScrolling = XULTB_FALSE;
		GUI_LOG("Text input box...... label:[%1.1s], text:[%1.1s]\n", label?label->str:"", text?text->str:"");

		struct xultb_list_item*ret = xultb_list_item_create_text_input_full(label, text,
				xultb_list_item_attr_is_positive(elem, "w"), XULTB_TRUE);
		return ret;
	} else if (xultb_str_equals_static(name, "s")) {

		// get selected index
		xultb_str_t*buffer = xultb_str_alloc(NULL, 512, NULL, 0);
		int first = XULTB_TRUE;
		int i;
//		int count = OPP_FACTORY_USE_COUNT(&elem->children);
		for (i = 0; ; i++) {
			struct xultb_ml_node*obj;
			opp_at_ncode2(obj, struct xultb_ml_node*, (&elem->children), i,
				// see if it is selected
				if (obj->elem.type == XULTB_ELEMENT_NODE && xultb_list_item_attr_is_positive(obj, "s")) {
					xultb_str_t*tmp = xultb_ml_get_text(obj);
					if (tmp) {
						if (first) {
							first = XULTB_FALSE;
						} else {
							xultb_str_cat_char(buffer, ',');
						}
						tmp = xultb_str_trim(tmp);
						xultb_str_cat(buffer, tmp);
					}
				}
			) else {
				break;
			}
		}

		// do not scroll continuously when there is selection box
		mlist->continuousScrolling = XULTB_FALSE;
		return xultb_list_item_create_selection_box(label, buffer,
				XULTB_TRUE);
	} else if (xultb_str_equals_static(name, "r")) {
		// render radio button

		return xultb_list_item_create_radio_button(label,
				xultb_list_item_attr_is_positive(elem, "c"), XULTB_TRUE);
	} else if (xultb_str_equals_static(name, "ch")) {
		// so it is checkbox

		return xultb_list_item_create_checkbox(label,
				xultb_list_item_attr_is_positive(elem, "c"), XULTB_TRUE);
	} else if (xultb_str_equals_static(name, "o")) {
		// so it is selection option
		// get current text
		xultb_str_t*text = NULL;
		if (OPP_FACTORY_USE_COUNT(&elem->children) == 0 || (text = xultb_ml_get_text(elem)) == NULL) {

			// get hint of this field
			text = xultb_ml_get_attribute_value(elem, "h");
			if (text == NULL) {
				text = BLANK_STRING;
			}
		} else {

			// get rid of spaces
			text = xultb_str_trim(text);
		}

		// see if it is multiple selection box ..
		if (mlist->isMultipleSelection) {

			// see if it is selected ..
			return xultb_list_item_create_checkbox(text,
					xultb_list_item_attr_is_positive(elem, "s"), XULTB_TRUE);
		} else {
			return xultb_list_item_create_label_full(text, NULL, XULTB_TRUE, XULTB_FALSE, NULL);
		}
	} else {
		return (struct xultb_list_item*)xultb_markup_item_create(elem, mlist->ml, XULTB_FALSE, mlist->el);
	}
	return NULL;
}


}
