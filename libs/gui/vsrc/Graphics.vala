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
/*! \class xultb_graphics
 * This is responsible for drawing the total interface.
 * It is implemented in the platform.
 **/
public abstract class roopkotha.Graphics {
	public enum anchor {
		TOP = 1,
		HCENTER = (1<<1),
		LEFT = (1 << 2),
		RIGHT = (1 << 3),
		BOTTOM = (1 << 4),
	}
#if 0
	void clipRect(int x, int y, int width, int height);
	void copyArea(int x_src, int y_src, int width, int height, int x_dest, int y_dest, int anchor);
	void drawArc(int x, int y, int width, int height, int startAngle, int arcAngle);
	void drawChar(char character, int x, int y, int anchor);
	void drawChars(aroop.txt data, int offset, int length, int x, int y, int anchor);
#endif
	public abstract void draw_image(onubodh.RawImage img, int x, int y, int anchor);
	public abstract void draw_line(int x1, int y1, int x2, int y2);
	public abstract void draw_rect(int x, int y, int width, int height);
#if 0
	void drawRegion(struct xultb_img*src, int x_src, int y_src, int width, int height, int transform, int x_dest, int y_dest, int anchor);
	void drawRGB(int *rgbData, int offset, int scanlength, int x, int y, int width, int height, boolean processAlpha);
#endif
	public abstract void draw_round_rect(int x, int y, int width, int height, int arcWidth, int arcHeight);
	public abstract void draw_string(aroop.txt str, int x, int y, int width, int height, int anchor);
#if 0
	void drawSubstring(String str, int offset, int len, int x, int y, int anchor);
	void fillArc(int x, int y, int width, int height, int startAngle, int arcAngle);
#endif
	public abstract void fill_rect(int x, int y, int width, int height);
	public abstract void fill_round_rect(int x, int y, int width, int height, int arcWidth, int arcHeight);
	public abstract void fill_triangle(int x1, int y1, int x2, int y2, int x3, int y3);
#if 0
	int getBlueComponent();
	int getClipHeight();
	int getClipWidth();
	int getClipX();
	int getClipY();
#endif
	public abstract int  get_color();
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
	void setColor_full(int red, int green, int blue);
#endif
	public abstract void setFont(roopkotha.Font font);
#if 0
	void setGrayScale(int value);
	void setStrokeStyle(int style);
	void translate(int x, int y);
#endif
	public abstract void start();
}

