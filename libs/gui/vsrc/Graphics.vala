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
/**
 * \brief
 * This is responsible for drawing the total interface.
 * It is implemented in the platform.
 **/
public abstract class roopkotha.gui.Graphics : Replicable {
	[CCode (lower_case_cprefix = "ENUM_ROOPKOTHA_GRAPHICS_TASKS_")]
	public enum tasks {
		DRAW_IMAGE = 1,
		DRAW_STRING,
		DRAW_LINE,
		DRAW_RECT,
		DRAW_ROUND_RECT,
		FILL_RECT,
		FILL_ROUND_RECT,
		FILL_TRIANGLE,
		SET_COLOR,
		SET_FONT,
		START_LAYER,
	}
	[CCode (lower_case_cprefix = "ENUM_ROOPKOTHA_GRAPHICS_ANCHOR_")]
	public enum anchor {
		TOP = 1,
		HCENTER = (1<<1),
		LEFT = (1 << 2),
		RIGHT = (1 << 3),
		BOTTOM = (1 << 4),
	}
#if 0
	void clipRect(int x, int y, int width, int height);
	void copyArea(int x_src, int y_src, int width, int height, int x_dest, int y_dest, int anc);
	void drawArc(int x, int y, int width, int height, int startAngle, int arcAngle);
	void drawChar(char character, int x, int y, int anc);
	void drawChars(aroop.xtring data, int offset, int length, int x, int y, int anc);
#endif
	public abstract void drawImage(shotodol_media.RawImage img, int x, int y, int anc);
	public abstract void drawLine(int x1, int y1, int x2, int y2);
	public abstract void drawRect(int x, int y, int width, int height);
#if 0
	void drawRegion(struct xultb_img*src, int x_src, int y_src, int width, int height, int transform, int x_dest, int y_dest, int anc);
	void drawRGB(int *rgbData, int offset, int scanlength, int x, int y, int width, int height, boolean processAlpha);
#endif
	public abstract void drawRoundRect(int x, int y, int width, int height, int arcWidth, int arcHeight);
	public abstract void drawString(extring*str, int x, int y, int width, int height, int anc);
#if 0
	void drawSubstring(String str, int offset, int len, int x, int y, int anc);
	void fillArc(int x, int y, int width, int height, int startAngle, int arcAngle);
#endif
	public abstract void fillRect(int x, int y, int width, int height);
	public abstract void fillRoundRect(int x, int y, int width, int height, int arcWidth, int arcHeight);
	public abstract void fillTriangle(int x1, int y1, int x2, int y2, int x3, int y3);
#if 0
	int getBlueComponent();
	int getClipHeight();
	int getClipWidth();
	int getClipX();
	int getClipY();
#endif
	public abstract int  getColor();
#if 0
	int getDisplayColor(int color);
	Font getFont();
	int getGrayScale();
	int getGreenComponent();
	int getRedComponent();
	int getStrokeStyle();
	int getTranslateX();
	int getTranslateY();
	void setClip(int x, int y, int width, int height);
#endif
	public abstract void setColor(int rgb);
#if 0
	void setColorFull(int red, int green, int blue);
#endif
	public abstract void setFont(roopkotha.gui.Font font);
#if 0
	void setGrayScale(int val);
	void setStrokeStyle(int stl);
	void translate(int x, int y);
#endif
	public abstract void start(Window parent, int layer);
}

/** @} */
