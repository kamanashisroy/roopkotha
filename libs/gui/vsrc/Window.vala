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

public abstract class roopkotha.gui.Window : roopkotha.gui.Pane {
	txt title;
	public int width;
	public int halfWidth;
	public int height;
	public int menuY;
	public int panelTop;
	public int PADDING;
	WindowActionCB?windowActionCB;
	public GUIInput gi;
	protected Menu? menu;
	protected Font?TITLE_FONT;
	[CCode (lower_case_cprefix = "ENUM_ROOPKOTHA_GUI_WINDOW_TASK_")]
	public enum tasks {
		SHOW_WINDOW = 1,
		DESTROY,
	}
	public Window(etxt*aTitle) {
		core.assert(menu != null);
		title = new txt.memcopy_etxt(aTitle);
		this.init(200, 400);
		windowActionCB = null;
	}
	public virtual void init(int w, int h) {
		/** The width of the list */
		this.width = w;
		this.halfWidth = w>>1;

		/** The height of the list */
		/** Menu start position by pixel along Y-axis */
		this.height = h;
		this.menuY = h - menu.getBaseHeight();
		//this.menuY = h - 0;
		core.assert(TITLE_FONT != null);
		this.panelTop = TITLE_FONT.getHeight() + PADDING*2;
	}
	public abstract void show();
	public void showFull(ArrayList<EventOwner>*left_option, EventOwner right_option) {
		menu.set(left_option, right_option);
		menu.setParent(this);
		this.show();
	}
	public bool is_showing() {
		//XULTB_CORE_UNIMPLEMENTED();
		return true;
	}
	public virtual void set_title(aroop.txt title) {
		this.title = title;
	}
	
	public virtual void prePaint(roopkotha.gui.Graphics g) {
		g.start();
	}

	public override void paint(roopkotha.gui.Graphics g) {
		paint_title(g);
		//menu.paint(this, g, width, height);
	}
	
	public virtual void postPaint(roopkotha.gui.Graphics g) {
	}

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
			GUICore.setDirty(this);
			return true;
		}
		return false;
	}

	void paint_title(roopkotha.gui.Graphics g) {
		/* Cleanup Background */
		// #expand g.setColor(%net.ayaslive.miniim.ui.core.window.titleBg%);
		g.setColor(0x006699);
		g.fillRect(0, 0, this.width, this.panelTop);
		// #ifdef net.ayaslive.miniim.ui.core.window.titleShadow
		// draw shadow
		// #expand g.setColor(%net.ayaslive.miniim.ui.core.window.titleShadow%);
		g.setColor(0x009900);
		g.drawLine(0, this.panelTop, this.width, this.panelTop);
		// #endif
		/* Write the title */
		// #expand g.setColor(%net.ayaslive.miniim.ui.core.window.titleFg%);
		g.setColor(0xFFFFFF);
		g.setFont(TITLE_FONT);
		g.drawString(title, 0, 2
				, width
				//, height
				, panelTop
				//, 1);
				, roopkotha.gui.Graphics.anchor.TOP |roopkotha.gui.Graphics.anchor.HCENTER);
		//core.assert("Reached" == null);
	}

	public abstract roopkotha.gui.Font getFont(roopkotha.gui.Font.Face face, roopkotha.gui.Font.Variant vars);

	public abstract int setPane(int pos, Pane pn);
}

/** @} */
