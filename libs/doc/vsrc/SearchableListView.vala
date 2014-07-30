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
 * \ingroup gui
 * @defgroup doc Document rendering
 */

/** \addtogroup doc
 *  @{
 */
#if false
public class roopkotha.doc.SearchableListView : roopkotha.gui.ListView {
	private Node node = null;
	private EventListener el = null;
	private MediaLoader ml = null;
	protected String defaultCommand = null;
	private String rightOption = null;
	private final String[] leftMenuOptions = {null, null, null, null, null, null, null, null};
	private final static StringBuffer buff = new StringBuffer();
	private int lastRow = 0;
	private int lastCol = 0;
	private long lastEvent = 0;
	private boolean keyRepeated = false;
	private boolean searching = false;
	private boolean isMultipleSelection = false;
	private char[][] keys = {
			{'0', ' '},
			{'1', '.', ','},
			{'2', 'a', 'b', 'c', 'A', 'B', 'C'},
			{'3', 'd', 'e', 'f', 'D', 'E', 'F'},
			{'4', 'g', 'h', 'i', 'G', 'H', 'I'},
			{'5', 'j', 'k', 'l', 'J', 'K', 'L'},
			{'6', 'm', 'n', 'o', 'M', 'N', 'O'},
			{'7', 'p', 'q', 'r', 's', 'P', 'Q', 'R', 'S'},
			{'8', 't', 'u', 'v', 'T', 'U', 'V'},
			{'9', 'w', 'x', 'y', 'z', 'W', 'X', 'Y', 'Z'},
	};

	public SearchableListView() {
		searching = false;
		continuousScrolling = true;
	}
	
	public boolean handleElement(int keyCode, int gameAction) {
		int index = super.getSelectedIndex();
		
		// avoid invalid selected index
		if(index >= node.getChildCount()) {
			return false;
		}
		
		// allow markup traversing
		Element elem = (Element)node.getChild(index);
		ListItem item = getListItem(elem);
		if(item instanceof MarkupItem) {
			if(((MarkupItem)item).keyPressed(keyCode, gameAction)) {
				item.free();
				return true;
			}
		}
		item.free();
		
		// see if it is any text
		if(keyCode < Canvas.KEY_NUM0 || keyCode > Canvas.KEY_NUM9) {
			item.free();
			searching = false;
			return false;
		}
		long curTime = System.currentTimeMillis();
		if(curTime - lastEvent > 1000 || (keyCode - Canvas.KEY_NUM0) != lastRow) { // 1 second
			
			// new key
			lastRow = keyCode - Canvas.KEY_NUM0;
			lastCol = 0;
			keyRepeated = false;
		} else {
			
			// updated key
			if(++lastCol > keys[lastRow].length) {
				lastCol = 0;
			}
			keyRepeated = true;
		}
		lastEvent = curTime;
		
		if(item instanceof ListItemFactory) {
			ListItemFactory li = (ListItemFactory)item;
			
			if(li.getType() == ListItemFactory.TEXT_INPUT) {
				
				// allow inline text editing
				doEdit(elem);
				item.free();
				return true;
			}
		}

		// allow searching
		doSearch();
		item.free();
		return true;
	}
	
	/** Searching */
	private void doSearch() {
		int length = 0;
		if(!searching) {
			buff.setLength(0);
			length = 0;
		} else {
			length = buff.length();
		}
		searching = true;
		if(keyRepeated) {
			
			// toggle the last character
			buff.setCharAt(length - 1, keys[lastRow][lastCol]);
		} else {
			
			// do not allow search prefix greater than 4 character
			if(length < 4) {
				buff.append(keys[lastRow][lastCol]);
			}
		}
		String prefix = buff.toString();
		Window.pushBalloon(prefix, null, hashCode(), 1000);
		boolean found = false; // found flag
		final int count = node.getChildCount();
		// traverse the child
		for(int i = 0; i < count && !found; i++) {
			Element elem = (Element)node.getChild(i);
			final int size = elem.getChildCount();
			for(int j = 0; j < size; j++) {
				if(elem.getType(j) == Node.TEXT) {
					if(elem.getText(j).startsWith(prefix)) {
						found = true;
						setSelectedIndex(i);
					}
					break;
				}
			}
		}
	}
	
	private void doEdit(Element elem) {
		String oldText = null;
		final int count = elem.getChildCount();
		for(int i=0; i < count; i++) {
			oldText = elem.getText(0);
			elem.removeChild(0);
		}
		buff.setLength(0);
		if(oldText != null) {
			buff.append(oldText);
		}
		
		if(keyRepeated) {
			buff.setCharAt(buff.length() - 1, keys[lastRow][lastCol]);
		} else {
			buff.append(keys[lastRow][lastCol]);
		}
		
		// so we have solid text
		elem.addChild(Node.TEXT, buff.toString());
		buff.setLength(0);
	}
}
#endif
/** @} */
