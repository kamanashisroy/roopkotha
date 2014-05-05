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
 * [-Maturity- 0]
 */

public class roopkotha.vela.PageMenu : roopkotha.doc.DocumentView {
	EventOwner?rightOption;
	ArrayList<EventOwner?> leftOptions;
	int count;
	public PageMenu(etxt*gTitle, etxt*gAbout) {
		base(gTitle, gAbout);
		count = 0;
		rightOption = null;
		leftOptions = ArrayList<EventOwner>();
	}

	~PageMenu() {
		leftOptions.destroy();
	}

	public void resetMenu() {
		rightOption = null;
		int i = 0;
		for(i = 0; i < count; i++) {
			leftOptions.set(i, null);
		}
		count = 0;
	}

	public void addMenu(EventOwner?x) {
		if(rightOption == null ) {
			rightOption = x;
			return;
		}
		leftOptions.set(count, x);
		count++;
	}
	public  void finalizeMenu() {
		showFull(&leftOptions, rightOption);
	}		
}
/** @} */
