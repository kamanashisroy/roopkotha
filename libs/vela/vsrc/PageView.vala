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
using roopkotha.vela;

#if false
public class roopkotha.PageViewItem : roopkotha.ListViewItem {
	int update(struct xultb_list_item*item, xultb_str_t*text) {
		struct xultb_ml_node*node = item->target;
		SYNC_ASSERT(node);
		xultb_str_t*new_text = OPPREF(text);
		OPPUNREF(node->elem.content);
		GUI_INPUT_LOG("setting new text %s\n", new_text->str);
		node->elem.content = new_text;
		return 0;
	}
}
#endif

public class roopkotha.vela.PageView : roopkotha.DocumentView {
	RoopDocument? doc;
#if false
	static int update_impl(struct xultb_list_item*item, xultb_str_t*text) {
		struct xultb_ml_node*node = item->target;
		SYNC_ASSERT(node);
		xultb_str_t*new_text = OPPREF(text);
		OPPUNREF(node->elem.content);
		GUI_INPUT_LOG("setting new text %s\n", new_text->str);
		node->elem.content = new_text;
		return 0;
	}
#endif

#if false
/** Searching */
static void do_search() {
	int length = 0;
	if (!searching) {
		buff.setLength(0);
		length = 0;
	} else {
		length = buff.length();
	}
	searching = true;
	if (keyRepeated) {

		// toggle the last character
		buff.setCharAt(length - 1, keys[lastRow][lastCol]);
	} else {

		// do not allow search prefix greater than 4 character
		if (length < 4) {
			buff.append(keys[lastRow][lastCol]);
		}
	}
	xultb_str_t*prefix = buff.toString();
	Window.pushBalloon(prefix, NULL, hashCode(), 1000);
	boolean found = false; // found flag
	final int count = node.getChildCount();
	// traverse the child
	for (int i = 0; i < count && !found; i++) {
		Element elem = (Element) node.getChild(i);
		final int size = OPP_FACTORY_USE_COUNT(&elem->children);
		for (int j = 0; j < size; j++) {
			if (elem.getType(j) == Node.TEXT) {
				if (elem.getText(j).startsWith(prefix)) {
					found = true;
					setSelectedIndex(i);
				}
				break;
			}
		}
	}
}
#endif

}
