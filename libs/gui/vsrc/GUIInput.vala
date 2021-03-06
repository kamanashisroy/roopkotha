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
public class roopkotha.gui.EventOwner : Searchable {
	Replicable?source;
	extring label;
	public EventOwner.from_extring(extring*target) {
		source = null;
		if(target != null) {
			label = extring.copy_shallow(target);
		} else {
			label = extring();
		}
	}
	public EventOwner(Replicable target, extring*displayText) {
		source = target;
		if(displayText != null) {
			label = extring.copy_shallow(displayText);
		} else {
			label = extring();
		}
	}
	public void getLabelAs(extring*x) {
		x.rebuild_and_copy_shallow(&label);
	}
	public Replicable getSource() {
		return source;
	}
}

public abstract class roopkotha.gui.GUIInput : Replicable {

	[CCode (lower_case_cprefix = "ENUM_ROOPKOTHA_ACTION_INPUT_")]
	public enum eventType {
		KEYBOARD_EVENT = 1,
		SCREEN_EVENT = (1<<4), // touch / mouse event
	}

	[CCode (lower_case_cprefix = "ENUM_ROOPKOTHA_ACTION_INPUT_KEY_")]
	public enum keyEventType {
		KEY_UP = 1,
		KEY_DOWN = 2,
		KEY_LEFT = 3,
		KEY_RIGHT = 4,
		KEY_ENTER = 5,
		KEY_RETURN = 6,
		KEY_F1 = 7,
		KEY_F2 = 8,
		KEY_ESCAPE = 9,
	}

	public abstract int registerScreenEvent(EventOwner?target, int x, int y, int width, int height);
	public abstract int reset(roopkotha.gui.Window win); /*< This should be called before registering action */
}

/** @} */
