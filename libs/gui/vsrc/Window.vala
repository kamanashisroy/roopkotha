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

/**
 * \ingroup roopkotha
 * @defgroup gui GUI
 */

/** \addtogroup gui
 *  @{
 */
public delegate void roopkotha.gui.WindowActionCB(EventOwner action);

public abstract class roopkotha.gui.Window : Hashable {
	public int width;
	public int halfWidth;
	public int height;
	WindowActionCB?windowActionCB;
	public GUIInput gi;
	public Style style;
	protected InteractiveMenu menu;
	protected extring wPath;
	[CCode (lower_case_cprefix = "ENUM_ROOPKOTHA_GUI_WINDOW_TASK_")]
	public enum tasks {
		SHOW_WINDOW = 1,
		DESTROY,
		RESIZE,
		KEY_PRESS,
	}
	public enum layer {
		TITLE_BAR = 19,
		MENU_BAR = 20,
		CONTENT_PANE = 500,
	}
	public Window(extring*givenPath) {
		windowActionCB = null;
		style = Style();
		wPath = extring.copy_on_demand(givenPath);
		gi = GUICoreModule.gcore.createInputHandler(this, (int)wPath.getStringHash());
		menu = new InteractiveMenu(&style,gi,&wPath);
		setPane(layer.MENU_BAR, menu);
		onResize(200, 400);
	}
	public virtual int onResize(int w, int h) {
		/** The width of the list */
		width = w;
		halfWidth = w>>1;
		height = h;

		/** The height of the list */
		/** Menu start position by pixel along Y-axis */
		this.height = h;
		Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 3, "resize event()\n");
		return 0;
	}
	public abstract void show();
	public void showFull(ArrayList<EventOwner>*left_option, EventOwner right_option) {
		menu.set(left_option, right_option);
		this.show();
	}

	public int getWindowToken() { // this is used from guicore to identify it in other(platform) realm
		return (int)wPath.getStringHash();
	}

	public bool isShowing() {
		//XULTB_CORE_UNIMPLEMENTED();
		return true;
	}
	public abstract void setTitle(aroop.xtring title);
	
	public void onAction(EventOwner owner) {
		if(windowActionCB != null) {
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "windowActionCB()\n");
			windowActionCB(owner);
		}
	}

	public void setActionCB(WindowActionCB cb) {
		Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Set window action\n");
		if(windowActionCB == null) {
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "done\n");
			windowActionCB = cb;
		}
	}
	
	public virtual bool onEvent(EventOwner?target, int flags, int key_code, int x, int y) {
		if(menu.handleEvent(this, target, flags, key_code, x, y)) {
			GUICoreModule.gcore.setDirty(this);
			return true;
		}
		return false;
	}

	public abstract roopkotha.gui.Font getFont(roopkotha.gui.Font.Face face, roopkotha.gui.Font.Variant vars);

	public abstract int setPane(int pos, Pane pn);
}

/** @} */
