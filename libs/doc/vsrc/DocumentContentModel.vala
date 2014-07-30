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
using roopkotha.gui.listview;

/**
 * \ingroup gui
 * @defgroup doc Document rendering
 */

/** \addtogroup doc
 *  @{
 */
public class roopkotha.doc.DocumentContentModel : ListContentModel {
	RoopDocument? doc;
	public DocumentContentModel() {
		base();
		extring dlg = extring.set_static_string("Created DocumentContentModel\n");
		Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.DEBUG, 0, 0, "DocumentContentModel:created");
#if false
		// see if the node is selection box ..
		if(node instanceof Element) {
			Element elem = (Element)node;
			if(elem.getName().equals("s")) {
				// see if it has multiple choice ..
				isMultipleSelection = DefaultComplexListener.isPositiveAttribute(elem, "m");
			}
		}
#endif
	}
	public void setDocument(RoopDocument aDoc, int aSelectedIndex) {
		doc = aDoc;
		extring dlg = extring.stack(64);
		dlg.printf("DocumentContentModel:new document of %d lines\n", getCount());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dlg);
	}
	
	public AugmentedContent? getSelectedContent() {
		return doc.contents.get(selectedIndex);
	}
	
	protected override ArrayList<Replicable>*getItems() {
		core.assert(doc != null);
		return (doc == null)?null:&doc.contents;
	}

	protected override ListViewItem getListItem(Replicable given) {
		// get the element
		AugmentedContent elem = (AugmentedContent)given;
		extring data = extring();
		switch(elem.cType) {
			case AugmentedContent.ContentType.TEXT_INPUT_CONTENT:
			{
				elem.getTextAs(&data);
				extring label = extring();
				elem.getLabelAs(&label);
				
				return new ListViewItemComplex.createTextInputFull(&label, &data, elem.canBeWrapped(), true);
			}
				break;
			case AugmentedContent.ContentType.SELECTION_CONTENT:
			{
#if false
				// get selected index
				extring buffer = extring();
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
				extring label = extring();
				elem.getLabelAs(&label);
				return new ListViewItemComplex.createRadioButton(&label, elem.isChecked(), true);
			}
				break;
			case AugmentedContent.ContentType.CHECKBOX_CONTENT:
			{
				extring label = extring();
				elem.getLabelAs(&label);
				return new ListViewItemComplex.createCheckbox(&label, elem.isChecked(), true);
			}
				break;
			case AugmentedContent.ContentType.FORMATTED_CONTENT:
			{
				//return new MarkupItem.getInstance(elem, ml, false, el);
			}
				break;
			case AugmentedContent.ContentType.LABEL_CONTENT:
				break;
			default:
				break;
		}
		elem.getTextAs(&data);
		extring dlg = extring.stack(256);
		dlg.printf("Plain line :%s\n", data.to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 3, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dlg);
		// see if the label has any image
		return new ListViewItemComplex.createLabelFull(&data, elem.getImage(), elem.hasAction(), false, null);
	}
}
/** @} */
