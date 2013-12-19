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


public class roopkotha.DocumentView : roopkotha.ListView {
#if false
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
#endif	
	RoopDocument? doc;
	public DocumentView(etxt*aTitle, etxt*aDefaultCommand) {
		base(aTitle, aDefaultCommand);
		etxt dlg = etxt.from_static("Created DocumentView\n");
		Watchdog.logMsgDoNotUse(&dlg);
	}
	public void setDocument(RoopDocument aDoc, int aSelectedIndex) {
		doc = aDoc;
		etxt dlg = etxt.stack(64);
		dlg.printf("Set Document of %d lines\n", getCount());
		Watchdog.logMsgDoNotUse(&dlg);
#if false
		searching = false;
		continuousScrolling = true;
		
		base.setSelectedIndex(aSelectedIndex);
		// see if the node is selection box ..
		if(node instanceof Element) {
			Element elem = (Element)node;
			if(elem.getName().equals("s")) {
				// see if it has multiple choice ..
				isMultipleSelection = DefaultComplexListener.isPositiveAttribute(elem, "m");
			}
		}
		repaint();
#endif
	}
#if false	
	public void setEventListener(EventListener el) {
		this.el = el;
	}
	
	public void setMediaLoader(MediaLoader ml) {
		this.ml = ml;
	}
	public Element getSelectedItem() {
		return node.getElement(super.getSelectedIndex());
	}
#endif
	
#if false
	public void show() {
		searching = false;
		super.show(rightOption, leftMenuOptions);
	}
#endif
	
	public void setRightOption(etxt*rightOption) {
#if false
		this.rightOption = rightOption;
		// \xxx no locking :(
		if(isShowing()) {
			Menu.getInstance().setRightOption(rightOption);
		}
#endif
	}
	
	public void setLeftOption(int pos, etxt*command) {
#if false
		// \xxx no locking :(
		if(isShowing()) {
			Menu.getInstance().setLeftOption(pos, command);
		} else {
			leftMenuOptions[pos] = command;
		}
#endif
	}

#if false
	/// List implementation
	/*@{*/
	protected int getCount() {
		if(doc == null) {
			return 0;
		}
		return doc.getChildCount();
	}

	protected String getHint() {
		return null;
	}
#endif

	protected override ArrayList<Replicable>*getItems() {
		print("Showing list item 0\n");
		core.assert(doc != null);
		return (doc == null)?null:&doc.contents;
	}

	protected override ListViewItem getListItem(Replicable given) {
		// get the element
		print("Showing list item 2\n");
		AugmentedContent elem = (AugmentedContent)given;
		etxt data = etxt.stack(128);
		switch(elem.cType) {
			case AugmentedContent.ContentType.TEXT_INPUT_CONTENT:
			{
				elem.getText(&data);
				etxt label = etxt.EMPTY();
				elem.getLabel(&label);
				
				return new ListViewItemComplex.createTextInputFull(&label, &data, elem.canBeWrapped(), true);
			}
				break;
			case AugmentedContent.ContentType.SELECTION_CONTENT:
			{
#if false
				// get selected index
				etxt buffer = etxt.EMPTY();
				boolean first = true;
				final int count = elem.getChildCount();
				for(int i=0; i<count; i++) {
					Element op = elem.getElement(i);
					
					// see if it is selected
					if(DefaultComplexListener.isPositiveAttribute(op, "s")) {
						String tmp = op.getText(0);
						if(tmp == null) {
							continue;
						}
						if(first) {
							first = false;
						} else {
							buffer.append(',');
						}
						buffer.append(tmp.trim());
					}
				}
				
				// do not scroll continuously when there is selection box
				continuousScrolling = false;
				return new ListViewItemComplex.createSelectionBox(label, buffer.toString(), true);
#endif
			}
				break;
			case AugmentedContent.ContentType.RADIO_CONTENT:
			{
				etxt label = etxt.EMPTY();
				elem.getLabel(&label);
				return new ListViewItemComplex.createRadioButton(&label, elem.isChecked(), true);
			}
				break;
			case AugmentedContent.ContentType.CHECKBOX_CONTENT:
			{
				etxt label = etxt.EMPTY();
				elem.getLabel(&label);
				return new ListViewItemComplex.createCheckbox(&label, elem.isChecked(), true);
			}
				break;
			case AugmentedContent.ContentType.MARKUP_CONTENT:
			{
				//return new MarkupItem.getInstance(elem, ml, false, el);
			}
				break;
			case AugmentedContent.ContentType.LABEL_CONTENT:
				break;
			default:
				break;
		}
		elem.getText(&data);
		etxt dlg = etxt.stack(256);
		dlg.printf("Plain line :%s\n", data.to_string());
		Watchdog.logMsgDoNotUse(&dlg);
		// see if the label has any image
		return new ListViewItemComplex.createLabelFull(&data, elem.getImage(), elem.hasAction(), false, null);
	}
	
#if false
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
#endif
	/*@}*/
	
#if false
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
#endif

#if false
	/** Enumeration implementation */
	/*@{*/
	private int pos = 0;
	public boolean hasMoreElements() {
		if(node == null) {
			return false;
		}
		return pos < node.getChildCount();
	}

	public Object nextElement() {
		return node.getChild(pos++);
	}
	/*@}*/
#endif
}
