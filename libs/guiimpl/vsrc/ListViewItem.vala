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
/*!
 * \class xultb_list_item
 * This is rendered in \ref xultb_list.
 * */
/*! \memberof xultb_list_item */
public abstract class roopkotha.ListViewItem : Replicable {
	public enum itemtype {
		LABEL,
		SELECTION,
		TEXT_INPUT,
		CHECKBOX,
	}


	public enum display {
		PADDING = 2,
		RESOLUTION = 3,
		DPADDING = 5,
	}
	protected Replicable?target;
	protected etxt label;
	protected etxt text;
	protected bool checked;
	protected bool is_editable;
	protected bool is_radio;
	protected bool wrapped;
	protected bool truncate_text_to_fit_width;
	public bool focused;
	protected onubodh.RawImage? img;
	protected itemtype type; // enum sometype
	public roopkotha.Font ITEM_FONT;
	public int FONT_HEIGHT;
	public abstract int paint(roopkotha.Graphics g, int x, int y, int width, bool selected);
	public abstract bool DoEdit(int flags, int key_code, int x, int y);
	public abstract int update(etxt*xt);
}


#if FIXME_LATER
// define LIST_ITEM_SIGNATURE 0x93
xultb_list_item xultb_list_item_create_label(aroop.txt label, xultb_img img);
xultb_list_item xultb_list_item_create_label_full(aroop.txt label, xultb_img img
		, bool change_bg_on_focus , bool truncate_text_to_fit_width, Replicable target);
xultb_list_item xultb_list_item_create_selection_box(aroop.txt label, aroop.txt text, bool editable);
xultb_list_item xultb_list_item_create_text_input_full(aroop.txt label, aroop.txt text, bool wrapped, bool editable);
xultb_list_item xultb_list_item_create_text_input(aroop.txt label, aroop.txt text);
xultb_list_item xultb_list_item_create_checkbox(aroop.txt label, bool checked, bool editable);
xultb_list_item xultb_list_item_create_radio_button(aroop.txt label, bool checked, bool editable);

int xultb_list_item_system_init();
#endif

