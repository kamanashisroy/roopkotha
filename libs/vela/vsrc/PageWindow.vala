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
using roopkotha.gui.listview;
using roopkotha.doc;
using roopkotha.vela;

/** \addtogroup vela
 *  @{
 */
/**
 * You can only trust the numbers. 
 * [-Maturity- 20]
 */
public delegate void roopkotha.vela.PageEventCB(extring*action);
public delegate onubodh.RawImage? roopkotha.vela.GetImageCB(extring*imgAddr);

public class roopkotha.vela.PageWindow : roopkotha.vela.PageMenuLoader {
	PageEventCB?pageEventCB;
	GetImageCB?getImageCB;
	
	public PageWindow(extring*title, extring*path, extring*defCmd, PageContentModel?pcm = null) {
		base(title, path, defCmd, pcm == null?new PageContentModel():pcm);
		initPage();
	}

	void initPage() {
		pageEventCB = null;
		getImageCB = null;
	}

	public void setDocument(RoopDocument rd, int selectedIndex) {
		((PageContentModel)content).setDocument(rd, selectedIndex);
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
		extring action = extring();
		EventOwner owner = (EventOwner)target;
		AugmentedContent?elem = null;
		if(owner != null) {
			elem = (AugmentedContent)owner.getSource();
		} else {
			elem = (AugmentedContent)getSelected();
			if(elem == null) {
				return false;
			}
		}
		elem.getActionAs(&action);
		if(action.is_empty()) {
			return false;
		}
		pageEventCB(&action);
		return true;
	}
}
/** @} */
