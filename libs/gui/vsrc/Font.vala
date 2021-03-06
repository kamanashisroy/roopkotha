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

/** \addtogroup gui
 *  @{
 */
public abstract class roopkotha.gui.Font : Replicable {
	public enum Variant {
		UNDERLINED = 1,
		BOLD = (1 << 1),
		ITALIC = (1 << 2),
		PLAIN = (1 << 3),
		SMALL = (1 << 4),
		MEDIUM = (1 << 5),
		LARGE = (1 << 6),
	}

	public enum Face {
		DEFAULT = 1,
		SYSTEM = 2,
	}
	public abstract int getHeight();

	public abstract int subStringWidth(extring*str, int offset, int width);

	public abstract Font getVariant(Font.Variant stl);

	public abstract int getId();
#if GUI_DEBUG
	public abstract void dumpAll(extring*buf);
#endif
}

/** @} */
