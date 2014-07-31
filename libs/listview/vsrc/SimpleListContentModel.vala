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

/** \addtogroup listview
 *  @{
 */
public class roopkotha.gui.listview.SimpleListPaneModel : ListContentModel {
	aroop.ArrayList<Replicable> myitems;

	public SimpleListPaneModel() {
		base();
		myitems = ArrayList<Replicable>();
	}
	
	~SimpleListPaneModel() {
		myitems.destroy();
	}
	
	protected override aroop.ArrayList<Replicable>*getItems() {
		return &myitems;
	}
	
	protected override ListViewItem getListViewItem(Replicable data) {
		return (ListViewItem)data;
	}
	
	public void setListViewItem(int aIndex, ListViewItem aItem) {
		Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.DEBUG, 0, 0, "SimpleListView:adding list item");
		myitems.set(aIndex, aItem);
	}
}
/** @} */
