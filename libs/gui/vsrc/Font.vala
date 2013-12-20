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

public abstract class roopkotha.Font : Replicable {
	enum style {
		STYLE_UNDERLINED = 1,
		STYLE_BOLD = (1 << 1),
		STYLE_ITALIC = (1 << 2),
		STYLE_PLAIN = (1 << 3),
	}

	enum size {
		SIZE_SMALL = 1,
		SIZE_MEDIUM = 2,
		SIZE_LARGE = 3,
	}

	enum face {
		FACE_DEFAULT = 1,
		FACE_SYSTEM = 2,
	}

	public abstract int getHeight();

	public abstract int subStringWidth(etxt*str, int offset, int width);

#if false
	struct xultb_font*xultb_font_get(int face, int style, int size);
	int xultb_font_get_face(struct xultb_font*font);
	int xultb_font_get_style(struct xultb_font*font);
	int xultb_font_get_size(struct xultb_font*font);
#endif
}

