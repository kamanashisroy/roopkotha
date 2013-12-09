
#include "config.h"
#include "core/logger.h"
#include "ui/xultb_guicore.h"
#include "ui/core/xultb_window.h"

C_CAPSULE_START

/*!
 *
 * \page gui_block Gui
 *
 * This module renders gui in different platform.
 * Here we are trying to render xultb_list.
 * So at first we initiate guicore ..
 *
 * \code
 *
 * xultb_guicore_system_init(&argc, argv);
 *
 * \endcode
 *
 * Then we create \ref xultb_list.
 *
 * \code
 *  xultb_str_t*title = xultb_str_alloc_static("Test");
 *  xultb_str_t*dc = xultb_str_alloc_static("quit");
 *  struct xultb_list*list = xultb_list_create(title, dc);
 * \endcode
 *
 * Now add \ref xultb_list_item to list.
 *
 * \code
 *  xultb_str_t*elem = xultb_str_alloc_static("good");
 *  struct xultb_list_item*item = xultb_list_item_create_label(elem, NULL);
 *  opp_indexed_list_set(&list->_items, 0, item);
 * \endcode
 *
 * Add another item.
 * \code
 * elem = xultb_str_alloc_static("very good");
 * item = xultb_list_item_create_label(elem, NULL);
 * opp_indexed_list_set(&list->_items, 1, item);
 * \endcode
 *
 * Make the list visible.
 * \code
 * opp_extvt(list)->show(&list->super_data);
 * \endcode
 *
 * Now wait for user input.
 * \code
 * while(1) {
 * usleep(100);
 * xultb_guicore_walk(100);
 * }
 * \endcode
 *
 * Here are the defined classes and how they work.
 * \dot
 *  digraph G {
 *    size ="4,4";
 *    xultb_list [shape=box URL="\ref xultb_list"];
 *    xultb_window [shape=box URL="\ref xultb_window"];
 *    xultb_graphics [shape=box URL="\ref xultb_graphics"];
 *    xultb_list_item [shape=box URL="\ref xultb_list_item"];
 *    xultb_list -> xultb_window;
 *    xultb_list -> xultb_graphics;
 *    xultb_window -> xultb_graphics;
 *    xultb_list -> xultb_list_item;
 *    xultb_list_item -> xultb_graphics;
 *  }
 *  \enddot
 *
 */

int XULTB_PLATFORM_ENTER(main)(int argc, char *argv[]) {
	SYNC_LOG(SYNC_VERB, "Application started .\n");
	xultb_guicore_system_init(&argc, argv);

	xultb_str_t*title = xultb_str_alloc_static("Test");
	xultb_str_t*dc = xultb_str_alloc_static("quit");

	// create the list
	struct xultb_list*list = xultb_list_create(title, dc);
	SYNC_ASSERT(list);

	xultb_str_t*elem = xultb_str_alloc_static("good");
	struct xultb_list_item*item = xultb_list_item_create_label(elem, NULL);
	opp_indexed_list_set(&list->_items, 0, item);

	elem = xultb_str_alloc_static("very good");
	item = xultb_list_item_create_label(elem, NULL);
	opp_indexed_list_set(&list->_items, 1, item);

	opp_extvt(list)->show(&list->super_data);

	while(1) {
		usleep(100);
		xultb_guicore_walk(100);
	}
	return 0;
}

C_CAPSULE_END

