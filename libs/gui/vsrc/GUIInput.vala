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

public class roopkotha.GUIInput : Replicable {

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
		KEY_F1 = 6,
		KEY_F2 = 7,
	}

	public static int register_action(void*data, int x, int y, int width, int height) {
		return 0;
	}
	public static int reset(roopkotha.Window win) { /*< This should be called before registering action */
		return 0;
	}
	public static int init() {
		return 0;
	}
#if false
	public static int platform_init(int (*handle_event)(int flags, int key_code, int x, int y)) { /*< \private This will be implemented in the platform module */
		return 0;
	}
#endif
}

