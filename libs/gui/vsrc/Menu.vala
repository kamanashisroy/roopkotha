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
	bool menu_is_active = false;
	//static aroop.txt SELECT;
	EventOwner MENU;
	EventOwner CANCEL;
	EventOwner?rightOption; /* < will be displayed when menu is inactive */
	EventOwner FILLER;
	ArrayList<EventOwner>*menuOptions;

	int menuMaxWidth = -1;
	int menuMaxHeight = -1;


	int BASE_FONT_HEIGHT;
	int TOWER_MENU_ITEM_HEIGHT;
	int TOWER_FONT_HEIGHT;
	protected roopkotha.gui.Font TOWER_FONT;
	protected roopkotha.gui.Font BASE_FONT;

	int BASE_HEIGHT;
	int currentlySelectedIndex = 0;

	void draw_base(roopkotha.gui.Window parent, roopkotha.gui.Graphics g, int width, int height, EventOwner? left, EventOwner? right) {
		/* draw the background of the menu */
		// #expand g.setColor(%net.ayaslive.miniim.ui.core.menu.bgBase%);
		g.setColor(0x006699);
		g.fillRect(0, height - BASE_HEIGHT, width, BASE_HEIGHT);

		// #ifdef net.ayaslive.miniim.ui.core.menu.baseShadow
		// draw shadow
		// #expand g.setColor(%net.ayaslive.miniim.ui.core.menu.baseShadow%);
		g.setColor(0x006699);
		g.drawLine(0, height - BASE_HEIGHT, width, height - BASE_HEIGHT);
		// #endif

		/* draw left and right menu options */
		g.setFont(BASE_FONT);
		// #expand g.setColor(%net.ayaslive.miniim.ui.core.menu.fgBase%);
		g.setColor(0xFFFFFF);

		if(left != null) {
			etxt label = etxt.EMPTY();
			left.getLabel(&label);
			if(!label.is_empty_magical()) {
				parent.gi.registerScreenEvent(left, 0, height - BASE_HEIGHT, BASE_FONT.subStringWidth(&label, 0, label.length()), height);
				g.drawString(&label, roopkotha.gui.Menu.display.PADDING, 0, width, height - roopkotha.gui.Menu.display.PADDING, roopkotha.gui.Graphics.anchor.LEFT
						| roopkotha.gui.Graphics.anchor.BOTTOM);
//		SYNC_LOG(SYNC_VERB, "left option:%s\n", left.str);
			}
		}
		if(right != null) {
			etxt label = etxt.EMPTY();
			right.getLabel(&label);
			if(!label.is_empty_magical()) {
				parent.gi.registerScreenEvent(right, width - BASE_FONT.subStringWidth(&label, 0, label.length()), height - BASE_HEIGHT, width, height);
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
			etxt label = etxt.EMPTY();
			cmd.getLabel(&label);

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

	void draw_tower(roopkotha.gui.Window parent, roopkotha.gui.Graphics g, int width, int height,
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
		// #expand g.setColor(%net.ayaslive.miniim.ui.core.menu.bg%);
		g.setColor(0xFFFFFF);
		g.fillRect(0/* x */, menuOptionY/* y */, menuMaxWidth, menuMaxHeight);
		/* draw border of the menu */
		// #expand g.setColor(%net.ayaslive.miniim.ui.core.menu.borderTower%); // gray
		g.setColor(0xCCCCCC); // gray
		g.drawRect(0/* x */, menuOptionY/* y */, menuMaxWidth, menuMaxHeight);

		/* draw menu options (from up to bottom) */
		g.setFont(TOWER_FONT);

		int i = 0, j = 0;
		for (;menuOptions != null && i < menuOptions.count_unsafe();i++) {
			EventOwner cmd = menuOptions.get(i);
			etxt label = etxt.EMPTY();
			cmd.getLabel(&label);
			//opp_at_ncode(cmd, menuOptions, i,
			if (j != selectedOptionIndex) { /* draw unselected menu option */
				// #expand g.setColor(%net.ayaslive.miniim.ui.core.menu.fg%);
				g.setColor(0x000000);
			} else { /* draw selected menu option */
				/* draw a background */
				// #expand g.setColor(%net.ayaslive.miniim.ui.core.menu.bgHover%);
				g.setColor(0x0099CC);
				g.fillRect(0, menuOptionY, menuMaxWidth, TOWER_MENU_ITEM_HEIGHT);
				// #expand g.setColor(%net.ayaslive.miniim.ui.core.menu.borderHover%);
				g.setColor(0x006699);
				g.drawRect(0, menuOptionY, menuMaxWidth, TOWER_MENU_ITEM_HEIGHT);
				/**
				 * The simplest way to separate selected menu option is by
				 * drawing it with different color. However, it also may be
				 * painted as underlined text or with different background
				 * color.
				 */
				// #expand g.setColor(%net.ayaslive.miniim.ui.core.menu.fgHover%);
				g.setColor(0xFFFFFF);
			}

			parent.gi.registerScreenEvent(cmd, 0, menuOptionY
					, TOWER_FONT.subStringWidth(&label, 0, label.length())
					, menuOptionY + roopkotha.gui.Menu.display.PADDING*2 + TOWER_FONT_HEIGHT);
			menuOptionY += roopkotha.gui.Menu.display.PADDING;
			g.drawString(&label, roopkotha.gui.Menu.display.PADDING, menuOptionY, 1000, 1000,
					roopkotha.gui.Graphics.anchor.LEFT | Graphics.anchor.TOP);

			menuOptionY += roopkotha.gui.Menu.display.PADDING + TOWER_FONT_HEIGHT;
			j++;
		}
	}

	internal roopkotha.gui.Window?parent;
	internal void setParent(roopkotha.gui.Window gParent) {
		parent = gParent;
	}

	public override void paint(roopkotha.gui.Graphics g) {
		int width = parent.width;
		int height = parent.height;
#if false
		if(TOWER_FONT == null) {
			setupFont();
		}
#endif
		if(menu_is_active) {
			draw_base(parent, g, width, height, CANCEL, rightOption);
			draw_tower(parent, g, width, height, currentlySelectedIndex);
		} else {
			EventOwner?cmd;
			if(menuOptions != null && menuOptions.count_unsafe() == 1) {
				cmd = menuOptions.get(0);
				draw_base(parent, g, width, height, cmd, rightOption);
			} else if(menuOptions != null && menuOptions.count_unsafe() > 1){
				draw_base(parent, g, width, height, MENU, rightOption);
			} else {
				draw_base(parent, g, width, height, null, rightOption);
			}
		}
		dirty = false;
		return;
	}
	internal int getBaseHeight() {
		//core.assert("This is unimplemented" == null);
		return BASE_HEIGHT;
	}
	public roopkotha.gui.Font? getBaseFont() {
		core.assert("This is unimplemented" == null);
		return null;
	}
	public bool isActive() {
		return menu_is_active;
	}
	internal int set(ArrayList<EventOwner>*left_option, EventOwner? right_option) {
		if(right_option != null) {
			rightOption = right_option;
		} else {
			rightOption = FILLER;
		}
		menuOptions = left_option;
		menu_is_active = false;
		currentlySelectedIndex = 0;
		menuMaxHeight = menuMaxWidth = -1;
		return 0;
	}
	public bool handleEvent(roopkotha.gui.Window win, EventOwner?target, int flags, int key_code, int x, int y) {
		if((flags & roopkotha.gui.GUIInput.eventType.KEYBOARD_EVENT) != 0) {
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "keyboard : ..\n");
			switch(x) {
			case roopkotha.gui.GUIInput.keyEventType.KEY_UP:
				if(menu_is_active) {
					if(((currentlySelectedIndex - 1) >= 0))currentlySelectedIndex--;
					return true;
				} else {
					Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Menu is closed\n");
					return false;
				}
				break;
			case roopkotha.gui.GUIInput.keyEventType.KEY_DOWN:
				if(menu_is_active) {
					if(!((currentlySelectedIndex + 1) >= menuOptions.count_unsafe()))currentlySelectedIndex++;
					return true;
				} else {
					Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Menu is closed\n");
					return false;
				}
				break;
			case roopkotha.gui.GUIInput.keyEventType.KEY_F1:
				Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Menu left pressed\n");
	//			left = 1;
				if(menu_is_active) {
					target = CANCEL;
				} else {
					target = MENU;
				}
				break;
			case roopkotha.gui.GUIInput.keyEventType.KEY_F2:
				Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Menu right pressed\n");
				target = rightOption;
				break;
			case roopkotha.gui.GUIInput.keyEventType.KEY_ENTER:
			case roopkotha.gui.GUIInput.keyEventType.KEY_RETURN:
				Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Menu selected\n");
				if(menuOptions != null && menu_is_active) {
					EventOwner cmd = menuOptions.get(currentlySelectedIndex);
					if(cmd != null) {
						target = cmd;
					}
				} else {
					Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Menu is closed\n");
					return false;
				}
				break;
			case roopkotha.gui.GUIInput.keyEventType.KEY_ESCAPE:
				menu_is_active = false;
				return true;
			default:
				Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "This is not traversing key\n");
				return false;
			}
		}

		if(target == null) {
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "No target\n");
			return false;
		}


		int i;
		bool right = false, left = false;

		Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Menu Clicked\n");
		EventOwner? firstOption = null;

		if(target.is_same(rightOption)) {
			right = true;
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Right menu\n");
		} else if(menu_is_active) {
			if(target.is_same(CANCEL)) {
				left = true;
				Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Close menu\n");
			} else if(menuOptions != null)for (i=0;i<menuOptions.count_unsafe() && i >= 0;i++) {
				EventOwner cmd = menuOptions.get(i);
				if(cmd == target) {
					left = true;
					i = -2; // break
					etxt dlg = etxt.stack(128);
					etxt label = etxt.EMPTY();
					cmd.getLabel(&label);
					dlg.printf("Left menu:%s", label.to_string());
					Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dlg);
				}
				if(i == 0) {
					firstOption = cmd;
				}
			}
		} else if(target == MENU){
			left = true;
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Open menu\n");
		}
		if(!right && !left) {
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Not a menu event\n");
			return false;
		}

	//				if(length == currentlySelectedIndex) {
	//					selectedOption = menuOptions[i];
	//				}
		if (right) {
	//		SYNC_LOG(SYNC_VERB, "TODO: handle right command:%s\n", ((aroop.txt )target).str);
			Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 10, "Window action\n");
			win.onAction(rightOption);
			menu_is_active = false;
		} else if (menu_is_active) {
			if(target.is_same(CANCEL as Replicable)) {
				menu_is_active = false;
			} else {
	//			SYNC_LOG(SYNC_VERB, "TODO: handle left command:%s\n", ((aroop.txt )target).str);
				win.onAction(target);
				menu_is_active = false;
			}
		} else {
			/* check if the "Options" or "Exit" buttons were pressed */
			if(menuOptions == null) {
				/* This is not menu action */
				return false;
			}
			if(menuOptions.count_unsafe() == 1) {
	//				SYNC_LOG(SYNC_VERB, "TODO: handle first left command:%s\n", ((aroop.txt )target).str);
				/* this is direct action */
				win.onAction(firstOption);
			} else {
				currentlySelectedIndex = 0;
				menu_is_active = true;
			}
		}
		return true; /* menu action has done something, so the action is digested */
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
	public Menu(Font aTowerFont, Font aBaseFont) {
	//	SYNC_ASSERT(opp_indexed_list_create2(menuOptions, 16) == 0);
		//memclean_raw();
		TOWER_FONT = aTowerFont;
		BASE_FONT = aBaseFont;
		menuOptions = null;
		parent = null;
		setupFont();
	//	SELECT = aroop.txt.alloc("Select", 6, null, 0);
		etxt cancelText = aroop.etxt.from_static("Cancel");
		CANCEL = new EventOwner.from_etxt(&cancelText);
		etxt menuText = aroop.etxt.from_static("Menu");
		MENU = new EventOwner.from_etxt(&menuText);
		etxt filterText = aroop.etxt.from_static("Filter");
		FILLER = new EventOwner.from_etxt(&filterText);
		rightOption = FILLER;
		dirty = true;
	}
}
/** @} */

