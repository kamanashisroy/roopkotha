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

public class roopkotha.SimpleListView : roopkotha.ListView {
	aroop.ArrayList<Replicable> myitems;

	public SimpleListView(etxt*aTitle, etxt*aDefaultCommand) {
		base(aTitle, aDefaultCommand);
		myitems = ArrayList<Replicable>();
	}
	
	~SimpleListView() {
		myitems.destroy();
	}
	
	public override aroop.ArrayList<Replicable>*get_items() {
		return &myitems;
	}
	
	public override roopkotha.ListViewItem getListItem(Replicable data) {
		return (roopkotha.ListViewItem)data;
	}
	
	public void setListViewItem(int aIndex, ListViewItem aItem) {
		Watchdog.logString("SimpleListView:adding list item\n");
		myitems.set(aIndex, aItem);
	}
}