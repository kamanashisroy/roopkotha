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
/*!
 * \class ListViewItem
 * This is rendered in \ref ListView.
 * */
/*! \memberof ListViewItem */
public abstract class roopkotha.ListViewItem : Replicable {
	public enum itemtype {
		LABEL,
		SELECTION,
		TEXT_INPUT,
		CHECKBOX,
	}

	public enum display {
		PADDING = 2,
		RESOLUTION = 3,
		DPADDING = 5,
	}
	public abstract bool doEdit(int flags, int key_code, int x, int y);
	public abstract int update(etxt*xt);
}
