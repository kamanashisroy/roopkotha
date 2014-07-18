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
using roopkotha.platform;
using roopkotha.gui;

/** \addtogroup guiimpl
 *  @{
 */
/*!
 * This is rendered in \ref ListView.
 * */
public abstract class roopkotha.gui.ListViewItem : Replicable {
	public enum itemtype {
		LABEL,
		SELECTION,
		TEXT_INPUT,
		CHECKBOX,
		OTHER,
	}

	public enum display {
		PADDING = 2,
		RESOLUTION = 3,
		DPADDING = 5,
	}
	public bool focused;
	protected itemtype type; // enum sometype
	public abstract int paint(roopkotha.gui.Window parent, roopkotha.gui.Graphics g, int x, int y, int width, bool selected);
	public abstract bool doEdit(int flags, int key_code, int x, int y);
	public abstract int update(extring*xt);
}
/** @} */
