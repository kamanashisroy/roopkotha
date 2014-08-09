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
public abstract class roopkotha.gui.GUICore : Spindle {
	protected Queue<Window> painter;
	GUIInput gin;
	[CCode (lower_case_cprefix = "ENUM_ROOPKOTHA_GUI_CORE_TASK_")]
	public enum entries {
		GRAPHICS_TASK = 1,
		WINDOW_TASK,
		ARG,
	}
	public GUICore() {
		painter = Queue<Window>();
	}
	~GUICore() {
		painter.destroy();
	}

	public int setDirtyFull(roopkotha.gui.Window win, int x1, int y1, int x2, int y2) {
		return setDirty(win);
	}

	public int setDirty(roopkotha.gui.Window win) {
		Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, "GUICore:setDirty: Marking it dirty");
		painter.enqueue(win);
		return 0;
	}
	public override int cancel() {
		return 0;
	}
	public abstract GUIInput createInputHandler(Window win, int token);
	public abstract void pushTask(extring*task);
	public abstract void pushGraphicsTask(Graphics g);
	public abstract void popTaskAs(extring*task);
}
/** @} */
