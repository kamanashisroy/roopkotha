/*
 * This file part of Roopkotha.
 *
 * Copyright (C) 2014  Kamanashis Roy
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

/** \addtogroup guiimpl
 *  @{
 */
/**
 * \brief
 * This is responsible for drawing the image in commands, so that it can be drawn/redrawn or backed up for use.
 **/
public class roopkotha.gui.GraphicsPixelMap : Graphics {
	Bundler bndlr;
	int currentColor;
	internal GUITask?task;
	bool finalized;
	int size;
	GraphicsPixelMap.Full(Carton*ctn, int gSize) {
		bndlr = Bundler();
		size = gSize;
		bndlr.buildFromCarton(ctn, size);
		currentColor = 1;
		finalized = false;
	}
	public GraphicsPixelMap.fromTask(GUITask gTask) {
		// allocate memory from factory
		task = gTask;
		Watchdog.logInt(core.sourceFileName(), core.sourceLineNo(), 10, "task.size", task.size);
		GraphicsPixelMap.Full(&task.msg, task.size);
	}
	public override void drawImage(onubodh.RawImage img, int x, int y, int anc) {
		bndlr.writeInt(GUICore.entries.GRAPHICS_TASK, tasks.DRAW_IMAGE);
		bndlr.writeBin(GUICore.entries.ARG, img.rawData, img.width*img.height*((img.type == onubodh.RawImage.RawImageType.PGM)?1:3));
		bndlr.writeInt(GUICore.entries.ARG, x);
		bndlr.writeInt(GUICore.entries.ARG, y);
		bndlr.writeInt(GUICore.entries.ARG, anc);
	}
	public override void drawLine(int x1, int y1, int x2, int y2) {
		bndlr.writeInt(GUICore.entries.GRAPHICS_TASK, tasks.DRAW_LINE);
		bndlr.writeInt(GUICore.entries.ARG, x1);
		bndlr.writeInt(GUICore.entries.ARG, y1);
		bndlr.writeInt(GUICore.entries.ARG, x2);
		bndlr.writeInt(GUICore.entries.ARG, y2);
	}
	public override void drawRect(int x, int y, int width, int height) {
		bndlr.writeInt(GUICore.entries.GRAPHICS_TASK, tasks.DRAW_RECT);
		bndlr.writeInt(GUICore.entries.ARG, x);
		bndlr.writeInt(GUICore.entries.ARG, y);
		bndlr.writeInt(GUICore.entries.ARG, width);
		bndlr.writeInt(GUICore.entries.ARG, height);
	}
	public override void drawRoundRect(int x, int y, int width, int height, int arcWidth, int arcHeight) {
		bndlr.writeInt(GUICore.entries.GRAPHICS_TASK, tasks.DRAW_ROUND_RECT);
		bndlr.writeInt(GUICore.entries.ARG, x);
		bndlr.writeInt(GUICore.entries.ARG, y);
		bndlr.writeInt(GUICore.entries.ARG, width);
		bndlr.writeInt(GUICore.entries.ARG, height);
		bndlr.writeInt(GUICore.entries.ARG, arcWidth);
		bndlr.writeInt(GUICore.entries.ARG, arcHeight);
	}
	public override void drawString(extring*str, int x, int y, int width, int height, int anc) {
		bndlr.writeInt(GUICore.entries.GRAPHICS_TASK, tasks.DRAW_STRING);
		bndlr.writeETxt(GUICore.entries.ARG, str);
		bndlr.writeInt(GUICore.entries.ARG, x);
		bndlr.writeInt(GUICore.entries.ARG, y);
		bndlr.writeInt(GUICore.entries.ARG, width);
		bndlr.writeInt(GUICore.entries.ARG, height);
		bndlr.writeInt(GUICore.entries.ARG, anc);
	}
	public override void fillRect(int x, int y, int width, int height) {
		core.assert(width >= 0);
		bndlr.writeInt(GUICore.entries.GRAPHICS_TASK, tasks.FILL_RECT);
		bndlr.writeInt(GUICore.entries.ARG, x);
		bndlr.writeInt(GUICore.entries.ARG, y);
		bndlr.writeInt(GUICore.entries.ARG, width);
		bndlr.writeInt(GUICore.entries.ARG, height);
	}
	public override void fillRoundRect(int x, int y, int width, int height, int arcWidth, int arcHeight) {
		bndlr.writeInt(GUICore.entries.GRAPHICS_TASK, tasks.FILL_ROUND_RECT);
		bndlr.writeInt(GUICore.entries.ARG, x);
		bndlr.writeInt(GUICore.entries.ARG, y);
		bndlr.writeInt(GUICore.entries.ARG, width);
		bndlr.writeInt(GUICore.entries.ARG, height);
		bndlr.writeInt(GUICore.entries.ARG, arcWidth);
		bndlr.writeInt(GUICore.entries.ARG, arcHeight);
	}
		
	public override void fillTriangle(int x1, int y1, int x2, int y2, int x3, int y3) {
		bndlr.writeInt(GUICore.entries.GRAPHICS_TASK, tasks.FILL_TRIANGLE);
		bndlr.writeInt(GUICore.entries.ARG, x1);
		bndlr.writeInt(GUICore.entries.ARG, y1);
		bndlr.writeInt(GUICore.entries.ARG, x2);
		bndlr.writeInt(GUICore.entries.ARG, y2);
		bndlr.writeInt(GUICore.entries.ARG, x3);
		bndlr.writeInt(GUICore.entries.ARG, y3);
	}
	public override int  getColor() {
		return currentColor;
	}
	public override void setColor(int rgb) {
		if(currentColor == rgb) return ; // optimize
		currentColor = rgb;
		bndlr.writeInt(GUICore.entries.GRAPHICS_TASK, tasks.SET_COLOR);
		bndlr.writeInt(GUICore.entries.ARG, rgb);
	}
	public override void setFont(roopkotha.gui.Font font) {
		bndlr.writeInt(GUICore.entries.GRAPHICS_TASK, tasks.SET_FONT);
		bndlr.writeInt(GUICore.entries.ARG, font.getId());
	}
	public override void start(Window parent, int layer) {
		finalized = false;
		bndlr.size = size;
		bndlr.writeInt(GUICore.entries.GRAPHICS_TASK, tasks.START_LAYER);
		WindowImpl w = (WindowImpl)parent;
		bndlr.writeInt(GUICore.entries.ARG, w.windowId);
		bndlr.writeInt(GUICore.entries.ARG, layer);
	}
	public void finalize() {
		if(finalized) return;
		task.finalize(&bndlr);
		finalized = true;
	}
}

/** @} */
