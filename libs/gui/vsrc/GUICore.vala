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

public abstract class roopkotha.GUICore : Spindle {
	Queue<Window> painter;
	Graphics gfx;
	static GUICore? gcore;
	public GUICore(Graphics g) {
		painter = Queue<Window>();
		gfx = g;
		gcore = this;
	}
	~GUICore() {
		painter.destroy();
	}
#if FIXME_LATER
static struct xultb_graphics*gr = NULL;
static struct opp_factory tasks;
int xultb_guicore_system_init(int*argc, char *argv[]) {
	opp_any_obj_system_init();
	xultb_guicore_platform_init(argc, argv);
	xultb_str_system_init();
	xultb_graphics_system_init();
	xultb_font_system_init();
	xultb_window_system_init();
	xultb_list_item_system_init();
	xultb_list_system_init();
	opp_queuesystem_init();
	xultb_gui_input_init();
	opp_queue_init2(&painter_queue, 0);
	opp_list_create2(&tasks, 4, 0);
	gr = xultb_graphics_create();
	return 0;
}
#endif

	public static int setDirtyFull(roopkotha.Window win, int x1, int y1, int x2, int y2) {
		return gcore.setDirty(win);
	}

	public static int setDirty(roopkotha.Window win) {
		print("Someone set the window dirty\n");
		gcore.painter.enqueue(win);
		return 0;
	}

#if FIXME_LATER
int xultb_guicore_register_task(struct xultb_gui_task*task) {
	opp_alloc4(&tasks, 0, 0, task);
	return 0;
}

int xultb_guicore_unregister_task(struct xultb_gui_task*task) {
	return opp_list_prune(&tasks, task, OPPN_ALL, 0, 0);
}

static int xultb_perform_tasks(void*data, void*func_data) {
	struct xultb_gui_task*task = ((struct opp_list_item*)data)->obj_data;
	int ms = *((int*)func_data);
	SYNC_ASSERT(task);
	task->cb_run(task, ms);
	return 0;
}
#endif
	
	public override int step() {
		do {
			Window? win = painter.dequeue();
			if(win == null) {
				break;
			}
			//xultb_gui_input_reset(win);
			win.prePaint(gfx);
			win.paint(gfx);
			win.postPaint(gfx);
		} while(true);
#if false
		opp_factory_do_full(&tasks, xultb_perform_tasks, &ms, OPPN_ALL, 0, 0);
#endif
		return 0;
	}
	public override int cancel() {
		return 0;
	}
}
