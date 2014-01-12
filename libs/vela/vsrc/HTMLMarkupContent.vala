/*
 * This file part of MiniIM.
 *
 * Copyright (C) 2007  Kamanashis Roy
 *
 * MiniIM is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * MiniIM is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with MiniIM.  If not, see <http://www.gnu.org/licenses/>.
 *
 */
using aroop;
using shotodol;
using roopkotha;

public class roopkotha.HTMLMarkupContent : FormattedContent {
	txt data;
	enum XMLCapsule {
		TAG_START = 100, // "<"
		TAG_END, // ">"
	}

	public HTMLMarkupContent(etxt*asciiData) {
		base();
		data = new txt.memcopy_etxt(asciiData);
		cType = ContentType.FormattedContent;
		print("FormattedContent:%s\n", data.to_string());
	}

	public override int getText(etxt*tData) {
		tData.concat(data);
		return 0;
	}

	public override bool isFocused() {
		xultb_str_t*focused = xultb_ml_get_attribute_value(elem, "focused");
		if(focused && xultb_str_equals_static(focused, "yes")) {
			return true;
		}
		return false;
	}

	public override bool isActive() {
		xultb_str_t*active = xultb_ml_get_attribute_value(elem, "active");
		if(active && xultb_str_equals_static(active, "yes")) {
			return true;
		}
		return false;
	}

	public void format(etxt*extract, FormattedTextCapsule*cap) {
		// sanity check
		if(extract.charAt(0) != XMLCapsule.TAG_START || extract.charAt(extract.length()-1) != XMLCapsule.TAG_END) {
			cap.textType = FormattedTextCapsule.FormattedTextType.UNKNOWN;
			return;
		}
		cap.textType = extract.charAt(1);
	}
	public void peelCapsule(etxt*extract, etxt*output) {
		// sanity check
		if(extract.charAt(0) != XMLCapsule.TAG_START || extract.charAt(extract.length()-1) != XMLCapsule.TAG_END) {
			cap.textType = FormattedTextCapsule.FormattedTextType.UNKNOWN;
			return;
		}
		int nextCapsule = 0;
		int len = extract.length();
		for (i = 0;i<len; i++) {
			if(extract.charAt(i) == XMLCapsule.TAG_END) {
				nextCapsule = i;
				break;
			}
		}
		if(nextCapsule == 0 || nextCapsule == len - 1) { // There is no internal capsule
			return;
		}
		int nextCapsuleEnd = 0;
		for (i = len-1;i; i--) {
			if(extract.charAt(i) == XMLCapsule.TAG_START) {
				nextCapsuleEnd = i;
				break;
			}
		}
		if(nextCapsuleEnd > nextCapsule) { // There is no internal capsule
			return;
		}
		*output = etxt.same_same(extract);
		output.trim(nextCapsuleEnd-1);
		output.shift(nextCapsule+1);
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
		break_line();
		if (position.equals("c")) {
			position = null;
		}
		g.drawImage(img, (position == null) ? width / 2 : xPos, yPos,
				Graphics.TOP
						| ((position == null) ? Graphics.HCENTER
								: position.equals("l") ? Graphics.LEFT
										: Graphics.RIGHT));
		update_height(imgHeight + XULTB_LIST_ITEM_PADDING);
		break_line();
	} else {
		if (width - xPos < imgWidth) {
			break_line();
		}
		g.drawImage(img, xPos, yPos, Graphics.TOP | Graphics.LEFT);

		// increase line height if the image height is larger ..
		imgHeight += XULTB_LIST_ITEM_PADDING;
		update_height(imgHeight > lineHeight ? imgHeight : lineHeight);

		xPos += imgWidth;
		xPos += 4;/* finally add a space: 4px */
		if (width - xPos < 0) { /* pushed too much */
			break_line();
		}
	}
#endif
}

static int getActualCardHeight(struct xultb_markup_item*item) {
	return item->yPos;
}

/** List item implementation .. */
/*@{*/
static int paint_impl(struct xultb_list_item*li, struct xultb_graphics*g, int x, int y, int width, int is_selected) {
	struct xultb_markup_item*item = (struct xultb_markup_item*)li;
	item->xPos = 0;
	item->yPos = 0;
	item->width = width;
//	item->is_selected = is_selected;
	// #expand g->set_color(%net.ayaslive.miniim.ui.core.markup.fg%);
	g->set_color(g, 0x006699);
	item->lineHeight = minLineHeight;
//	g.translate(x, y);

	// draw the line background
	clear_line(item, g);

	struct xultb_font*font = xultb_font_get(XULTB_FONT_FACE_DEFAULT, XULTB_FONT_STYLE_PLAIN, XULTB_FONT_SIZE_SMALL);
	// draw the node recursively
	render_node(item, g, font, (struct xultb_ml_node*)item->super_data.target);


	int ret = item->yPos;
	if (item->xPos != 0) {
		ret = item->yPos + item->lineHeight;
	}

	// fix the position and font
//	g->translate(-x, -y);
//	g->set_font(ITEM_FONT);
	return ret;
}

struct opp_vtable_xultb_list_item vtable_xultb_list_item_overriden;
opp_vtable_extern(xultb_list_item);
OPP_CB(xultb_markup_item) {
	struct xultb_markup_item*item = (struct xultb_markup_item*)data;
	memset(item, 0, sizeof(*item));
	switch(callback) {
	case OPPN_ACTION_INITIALIZE:
		item->loader = va_arg(ap, struct xultb_media_loader*);
		{
			va_list dummy;
			opp_super_cb(xultb_list_item)(&item->super_data, OPPN_ACTION_INITIALIZE, NULL, dummy, 0);
		}
		OPPUNREF(item->super_data.target); // may be not needed
		item->super_data.target = OPPREF(cb_data);
		opp_vtable_set(&item->super_data, xultb_list_item_overriden);
		return 0;
	case OPPN_ACTION_FINALIZE:
		{
			va_list dummy;
			opp_super_cb(xultb_list_item)(&item->super_data, OPPN_ACTION_FINALIZE, NULL, dummy, 0);
		}
		break;
	}
	return 0;
}

static struct opp_factory markup_item_factory;
struct xultb_list_item*xultb_markup_item_create(struct xultb_ml_node*root
		, struct xultb_media_loader*loader, xultb_bool_t selectable
		, struct xultb_event_listener*el) {
	return opp_alloc4(&markup_item_factory
				, 0, 0, root, loader, selectable, el);
}

int xultb_markup_item_system_init() {
	vtable_xultb_list_item_overriden = vtable_xultb_list_item;
	vtable_xultb_list_item_overriden.paint = paint_impl;
	struct xultb_font*font = xultb_font_get(XULTB_FONT_FACE_SYSTEM, XULTB_FONT_STYLE_PLAIN, XULTB_FONT_SIZE_SMALL);
	minLineHeight = font->get_height(font) + XULTB_LIST_ITEM_PADDING;
	OPPUNREF(font);
	SYNC_ASSERT(!OPP_FACTORY_CREATE(
			&markup_item_factory
			, 1,sizeof(struct xultb_markup_item)
			, OPP_CB_FUNC(xultb_markup_item)));
	return 0;
}

int xultb_markup_item_system_deinit() {
	opp_factory_destroy(&markup_item_factory);
	return 0;
}



static void xultb_page_set_node(struct xultb_page*mlist
		, struct xultb_ml_node*node, int selectedIndex) {
	mlist->root = node;
//	searching = false;
	mlist->continuousScrolling = XULTB_TRUE;

	opp_extvt(mlist)->set_selected_index(&mlist->super_data, selectedIndex);

#if 0
	// see if the node is selection box ..
	if(node instanceof Element) {
		Element elem = (Element)node;
		if(elem.getName().equals("s")) {
			// see if it has multiple choice ..
			isMultipleSelection = DefaultComplexListener.isPositiveAttribute(elem, "m");
		}
	}
#endif
	mlist->super_data.super_data.vtable->show_full(&mlist->super_data.super_data, &mlist->left_menu, mlist->right_menu);
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
