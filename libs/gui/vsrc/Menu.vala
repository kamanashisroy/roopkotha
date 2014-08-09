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
public abstract class roopkotha.gui.Menu : roopkotha.gui.Pane {
	public enum display {
		PADDING = 3
	}
	protected bool active = false;
	protected EventOwner MENU;
	protected EventOwner CANCEL;
	protected EventOwner?rightOption; /* < will be displayed when menu is inactive */
	protected EventOwner FILLER;
	protected ArrayList<EventOwner>*menuOptions;

	int menuMaxWidth = -1;
	int menuMaxHeight = -1;


	int BASE_FONT_HEIGHT;
	int TOWER_MENU_ITEM_HEIGHT;
	int TOWER_FONT_HEIGHT;
	protected roopkotha.gui.Font TOWER_FONT;
	protected roopkotha.gui.Font BASE_FONT;

	int BASE_HEIGHT;
	protected int selected = 0;
	protected int width = 0;
	protected int height = 0;
	GraphicsTask?gfx;
	Style*style;
	GUIInput input;
	extring path;

	public Menu(Style*givenStyle, GUIInput givenInput, extring*givenPath) {
		width = 0;
		height = 0;
		style = givenStyle;
		input = givenInput;
		path = extring.copy_on_demand(givenPath);
	//	SYNC_ASSERT(opp_indexed_list_create2(menuOptions, 16) == 0);
		//memclean_raw();
		TOWER_FONT = new BasicFont();
		BASE_FONT = new BasicFont();
		menuOptions = null;
		setupFont();
	//	SELECT = aroop.xtring.alloc("Select", 6, null, 0);
		extring cancelText = aroop.extring.set_static_string("Cancel");
		CANCEL = new EventOwner.from_extring(&cancelText);
		extring menuText = aroop.extring.set_static_string("Menu");
		MENU = new EventOwner.from_extring(&menuText);
		extring filterText = aroop.extring.set_static_string("Filter");
		FILLER = new EventOwner.from_extring(&filterText);
		rightOption = FILLER;
		dirty = true;
		gfx = null;
	}

	public override roopkotha.gui.Graphics getGraphics() {
		if(gfx != null)
			return gfx;
		Renu task = GUICoreModule.renuBuilder.createRenu(1024);
		gfx = new GraphicsTask.fromTask(task);
		return gfx;
	}

	void drawBase(roopkotha.gui.Graphics g, EventOwner? left, EventOwner? right) {
		/* draw the background of the menu */
		g.setColor(style.getColor(StyleTarget.MENU_BG_BASE));
		g.fillRect(0, height - BASE_HEIGHT, width, BASE_HEIGHT);

		if(!style.testFlag(StyleApproach.LIGHT)) {
			g.setColor(style.getColor(StyleTarget.MENU_BASE_SHADOW));
			g.drawLine(0, height - BASE_HEIGHT, width, height - BASE_HEIGHT);
		}

		/* draw left and right menu options */
		g.setFont(BASE_FONT);
		g.setColor(style.getColor(StyleTarget.MENU_FG_BASE));

		if(left != null) {
			extring label = extring();
			left.getLabelAs(&label);
			if(!label.is_empty_magical()) {
				input.registerScreenEvent(left, 0, height - BASE_HEIGHT, BASE_FONT.subStringWidth(&label, 0, label.length()), height);
				g.drawString(&label, roopkotha.gui.Menu.display.PADDING, 0, width, height - roopkotha.gui.Menu.display.PADDING, roopkotha.gui.Graphics.anchor.LEFT
						| roopkotha.gui.Graphics.anchor.BOTTOM);
//		SYNC_LOG(SYNC_VERB, "left option:%s\n", left.str);
			}
		}
		if(right != null) {
			extring label = extring();
			right.getLabelAs(&label);
			if(!label.is_empty_magical()) {
				input.registerScreenEvent(right, width - BASE_FONT.subStringWidth(&label, 0, label.length()), height - BASE_HEIGHT, width, height);
				g.drawString(&label, roopkotha.gui.Menu.display.PADDING, 0, width - roopkotha.gui.Menu.display.PADDING, height - roopkotha.gui.Menu.display.PADDING,
						roopkotha.gui.Graphics.anchor.RIGHT | roopkotha.gui.Graphics.anchor.BOTTOM);
			}
		}
	}

	void precalculate() {
		int currentWidth = 0;
		int i;
		/* we'll simply check each option and find the maximal width */
		for (i = 0; (menuOptions != null)  && i < menuOptions.count_unsafe(); i++) {
			EventOwner cmd = menuOptions.get(i);
			extring label = extring();
			cmd.getLabelAs(&label);

			currentWidth = TOWER_FONT.subStringWidth(&label, 0, label.length());
			if (currentWidth > menuMaxWidth) {
				menuMaxWidth = currentWidth; /* update */
			}
			menuMaxHeight += TOWER_FONT_HEIGHT + 2*roopkotha.gui.Menu.display.PADDING; /*
													 * for a current menu
													 * option
													 */
		}
		menuMaxWidth += 2 * roopkotha.gui.Menu.display.PADDING; /* roopkotha.gui.Menu.display.PADDING from left and right */
	}

	void drawTower(roopkotha.gui.Graphics g,
				int selectedOptionIndex) {

		/* draw menu options */
		if (menuOptions == null || menuOptions.count_unsafe() == 0) {
			return;
		}

		/* check out the max width of a menu (for the specified menu font) */
		if(menuMaxWidth == -1) {
			precalculate();
		}
		/* Tower top position */
		int menuOptionY = height - BASE_HEIGHT - menuMaxHeight - 1;

		/* now we know the bounds of active menu */

		/* draw active menu's background */
		g.setColor(style.getColor(StyleTarget.MENU_BG));
		g.fillRect(0/* x */, menuOptionY/* y */, menuMaxWidth, menuMaxHeight);
		/* draw border of the menu */
		g.setColor(style.getColor(StyleTarget.MENU_TOWER_BORDER));
		g.drawRect(0/* x */, menuOptionY/* y */, menuMaxWidth, menuMaxHeight);

		/* draw menu options (from up to bottom) */
		g.setFont(TOWER_FONT);

		int i = 0, j = 0;
		for (;menuOptions != null && i < menuOptions.count_unsafe();i++) {
			EventOwner cmd = menuOptions.get(i);
			extring label = extring();
			cmd.getLabelAs(&label);
			//opp_at_ncode(cmd, menuOptions, i,
			if (j != selectedOptionIndex) { /* draw unselected menu option */
				g.setColor(style.getColor(StyleTarget.MENU_FG));
			} else { /* draw selected menu option */
				/* draw a background */
				g.setColor(style.getColor(StyleTarget.MENU_BG_HOVER));
				g.fillRect(0, menuOptionY, menuMaxWidth, TOWER_MENU_ITEM_HEIGHT);
				g.setColor(style.getColor(StyleTarget.MENU_BORDER_HOVER));
				g.drawRect(0, menuOptionY, menuMaxWidth, TOWER_MENU_ITEM_HEIGHT);
				/**
				 * The simplest way to separate selected menu option is by
				 * drawing it with different color. However, it also may be
				 * painted as underlined text or with different background
				 * color.
				 */
				g.setColor(style.getColor(StyleTarget.MENU_FG_HOVER));
			}

			input.registerScreenEvent(cmd, 0, menuOptionY
					, TOWER_FONT.subStringWidth(&label, 0, label.length())
					, menuOptionY + roopkotha.gui.Menu.display.PADDING*2 + TOWER_FONT_HEIGHT);
			menuOptionY += roopkotha.gui.Menu.display.PADDING;
			g.drawString(&label, roopkotha.gui.Menu.display.PADDING, menuOptionY, 1000, 1000,
					roopkotha.gui.Graphics.anchor.LEFT | Graphics.anchor.TOP);

			menuOptionY += roopkotha.gui.Menu.display.PADDING + TOWER_FONT_HEIGHT;
			j++;
		}
	}

	void drawHint(roopkotha.gui.Graphics g) {
		extring hint = extring();
		extring hintex = extring.set_static_string("gui/window/menu/hint");
		Plugin.swarm(&hintex, &path, &hint);
		if (!hint.is_empty() && !isActive()) {
			g.setColor(style.getColor(StyleTarget.MENU_BG));
			g.setFont(BASE_FONT);
			g.drawString(&hint
					, 0
					, 0
					, width
					, height - roopkotha.gui.Menu.display.PADDING
					, roopkotha.gui.Graphics.anchor.HCENTER|roopkotha.gui.Graphics.anchor.BOTTOM);
			/* TODO show "<>"(90 degree rotated) icon to indicate that we can traverse through the list  */
		}
	}

	public override void paint(roopkotha.gui.Graphics g) {
#if false
		if(TOWER_FONT == null) {
			setupFont();
		}
#endif
		if(active) {
			drawBase(g, CANCEL, rightOption);
			drawTower(g, selected);
		} else {
			EventOwner?cmd;
			if(menuOptions != null && menuOptions.count_unsafe() == 1) {
				cmd = menuOptions.get(0);
				drawBase(g, cmd, rightOption);
			} else if(menuOptions != null && menuOptions.count_unsafe() > 1){
				drawBase(g, MENU, rightOption);
			} else {
				drawBase(g, null, rightOption);
			}
			drawHint(g);
		}
		dirty = false;
		return;
	}
	internal int getVerticalSpanTop() {
		//core.assert("This is unimplemented" == null);
		return BASE_HEIGHT;
	}
	public bool isActive() {
		return active;
	}
	internal int set(ArrayList<EventOwner>*left_option, EventOwner? right_option) {
		if(right_option != null) {
			rightOption = right_option;
		} else {
			rightOption = FILLER;
		}
		menuOptions = left_option;
		active = false;
		selected = 0;
		menuMaxHeight = menuMaxWidth = -1;
		return 0;
	}
	void setupFont() {
#if false
			TOWER_FONT = parent.getFont(roopkotha.gui.Font.Face.DEFAULT, roopkotha.gui.Font.Variant.PLAIN | roopkotha.gui.Font.Variant.SMALL);
			BASE_FONT = parent.getFont(roopkotha.gui.Font.Face.DEFAULT, roopkotha.gui.Font.Variant.BOLD | roopkotha.gui.Font.Variant.SMALL);
#endif
			core.assert(TOWER_FONT != null);
			core.assert(BASE_FONT != null);
			TOWER_FONT_HEIGHT = TOWER_FONT.getHeight();
			BASE_FONT_HEIGHT = BASE_FONT.getHeight();
			TOWER_MENU_ITEM_HEIGHT = TOWER_FONT_HEIGHT + 2*roopkotha.gui.Menu.display.PADDING;
			BASE_HEIGHT = BASE_FONT_HEIGHT + 2*roopkotha.gui.Menu.display.PADDING;
	}

}
/** @} */

