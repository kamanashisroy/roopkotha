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
#if false
		etxt dlg = etxt.stack(256);
		dlg.printf("PageView:Plain line :%s\n", data.to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dlg);
#endif
		// see if the label has any image
#if false
		return new ListViewItemComplex.createLabelFull(&data, elem.getImage(), elem.hasAction(), false, null);
#else
		etxt action = etxt.stack(128);
		elem.getAction(&action);
		EventOwner owner = new EventOwner(elem, &data);
		return new ListViewItemComplex.createLabelFull(&data, elem.getImage(), elem.hasAction(), false, owner);
#endif
	}

	public void setPageEvent(PageEventCB cb) {
		if(pageEventCB == null) {
			pageEventCB = cb;
		}
	}
	
	public void setImageLoader(GetImageCB cb) {
		if(getImageCB == null) {
			getImageCB = cb;
		}
	}

	public override bool onItemEvent(Replicable?target, int flags, int key_code, int x, int y) {
		if ((flags & roopkotha.gui.GUIInput.eventType.SCREEN_EVENT) == 0 && x != roopkotha.gui.GUIInput.keyEventType.KEY_ENTER && x != roopkotha.gui.GUIInput.keyEventType.KEY_RETURN) {
			return false;
		}
		if(pageEventCB == null) {
			return false;
		}
		etxt action = etxt.EMPTY();
		EventOwner owner = (EventOwner)target;
		AugmentedContent?elem = null;
		if(owner != null) {
			elem = (AugmentedContent)owner.getSource();
		} else {
			elem = (AugmentedContent)getSelectedContent();
			if(elem == null) {
				return false;
			}
		}
		elem.getAction(&action);
		if(action.is_empty()) {
			return false;
		}
		pageEventCB(&action);
		return true;
	}
}
/** @} */
