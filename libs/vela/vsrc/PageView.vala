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
using roopkotha.gui;
using roopkotha.doc;
using roopkotha.vela;

/** \addtogroup vela
 *  @{
 */
/**
 * You can only trust the numbers. 
 * [-Maturity- 20]
 */
public delegate void roopkotha.vela.PageEventCB(etxt*action);
public delegate onubodh.RawImage? roopkotha.vela.GetImageCB(etxt*imgAddr);

public class roopkotha.vela.PageView : roopkotha.vela.PageMenu {
	PageEventCB?pageEventCB;
	GetImageCB?getImageCB;
	FormattedListItem fli;
	etxt velaTitle;
	etxt aboutVela;
	public PageView() {
		velaTitle = etxt.from_static("Vela");
		aboutVela = etxt.from_static("About");
		base(&velaTitle, &aboutVela);
		initPage();
	}

	public PageView.of_title(etxt*ttl,etxt*abt) {
		base(ttl, abt);
		initPage();
	}

	void initPage() {
		pageEventCB = null;
		getImageCB = null;
		fli = new FormattedListItem();
	}
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

	protected override ListViewItem getListItem(Replicable given) {
		//print("Generating formatted list item\n");
		AugmentedContent elem = (AugmentedContent)given;
		if(elem.cType == AugmentedContent.ContentType.FORMATTED_CONTENT) {
			fli.factoryBuild((FormattedContent)elem);
			//print("-- formatted item generated\n");
			return fli;
		}
		etxt data = etxt.stack(128);
		elem.getText(&data);
		etxt dlg = etxt.stack(256);
		dlg.printf("PageView:Plain line :%s\n", data.to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dlg);
		// see if the label has any image
		return new ListViewItemComplex.createLabelFull(&data, elem.getImage(), elem.hasAction(), false, null);
	}

	public void setPageEvent(PageEventCB cb) {
		if(pageEventCB != null) {
			pageEventCB = cb;
		}
	}
	
	public void setImageLoader(GetImageCB cb) {
		if(getImageCB != null) {
			getImageCB = cb;
		}
	}
	
	public WebVariables?getVariables() {
		// TODO fill me
		return null;
	}
}
/** @} */
