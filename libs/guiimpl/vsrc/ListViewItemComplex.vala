using aroop;
using shotodol;
using roopkotha;

public class roopkotha.ListViewItemComplex : ListViewItem {
	public roopkotha.Font? ITEM_FONT;
	public int FONT_HEIGHT;
	public ListViewItemComplex.common() {
		ITEM_FONT = new FontImpl();
		FONT_HEIGHT = ITEM_FONT.getHeight();
		print("Item font is set");
	}
	void draw_selectionbox_icon(Graphics g, int x, int y, bool focused) {
		// now indicate that it is checked ..
		/* draw a rectangle */
		// #expand g.setColor(focused?(isEditable?%net.ayaslive.miniim.ui.core.list.listitemfactory.boxHover%:%net.ayaslive.miniim.ui.core.list.listitemfactory.boxHoverInactive%):%net.ayaslive.miniim.ui.core.list.listitemfactory.box%);
		g.setColor(focused ? (is_editable ? 0x006699 : 0x999999) : 0xCCCCCC);
		g.fillTriangle(x + ListViewItem.display.RESOLUTION / 2, y + ListViewItem.display.RESOLUTION, x + ListViewItem.display.RESOLUTION, y, x, y);
	}

	void draw_checkbox_icon(Graphics g, int x, int y, bool focused) {
		// draw a box
		// #expand g.setColor(focused?(isEditable?%net.ayaslive.miniim.ui.core.list.listitemfactory.boxHover%:%net.ayaslive.miniim.ui.core.list.listitemfactory.boxHoverInactive%):%net.ayaslive.miniim.ui.core.list.listitemfactory.box%);
		g.setColor(focused ? (is_editable ? 0x006699 : 0x999999) : 0xCCCCCC);
		if (is_radio) {

			// make the box a little curcular as it is radio button ..
			g.drawRoundRect(x + 1, y + 1, ListViewItem.display.RESOLUTION - 1, ListViewItem.display.RESOLUTION - 1, ListViewItem.display.DPADDING,
					ListViewItem.display.DPADDING);
		} else {

			g.drawRect(x + 1, y + 1, ListViewItem.display.RESOLUTION - 1, ListViewItem.display.RESOLUTION - 1);
		}

		// now indicate that it is checked ..
		if (checked) {

			if (is_radio) {

				g.fillRoundRect(x + 2, y + 2, ListViewItem.display.RESOLUTION - 2, ListViewItem.display.RESOLUTION - 2,
						ListViewItem.display.DPADDING, ListViewItem.display.DPADDING);
			} else {

				// #ifdef net.ayaslive.miniim.ui.core.list.listitemfactory.useTick
				//@     // draw tick
				//@     int bendX = x + ListViewItem.display.RESOLUTION/4 + 1;
				//@     g.drawLine(x + 1, y + ListViewItem.display.RESOLUTION/2, bendX, y + ListViewItem.display.RESOLUTION - 1);
				//@     g.drawLine(bendX, y + ListViewItem.display.RESOLUTION - 2, x + ListViewItem.display.RESOLUTION - 1, y + 1);
				// #else
				g.fillRect(x + 2, y + 2, ListViewItem.display.RESOLUTION - 2, ListViewItem.display.RESOLUTION - 2);
				// #endif
			}
		}
	}

	public override int paint(roopkotha.Window parent, roopkotha.Graphics g, int x, int y, int width, bool selected) {
		int start, pos, ret, labelWidth, labelHeight, lineCount;
		int imgspacing = 0;
		if (img != null) {
			imgspacing = img.width + ListViewItem.display.PADDING;
		}
		if (type == ListViewItem.itemtype.CHECKBOX) {
			imgspacing = ListViewItem.display.RESOLUTION + ListViewItem.display.PADDING;
		}

		print("Painting new label %s\n", label.to_string());
		core.assert(ITEM_FONT != null);
		// Write the Label
		labelWidth = labelHeight = start = pos = ret = lineCount = 0;
		if (!label.is_empty_magical()) {
			// #expand g.setColor(%net.ayaslive.miniim.ui.core.list.listitemfactory.fg%);
			g.setColor(0x000000);
			while ((pos = TextFormat.wrap_next(&label, ITEM_FONT, start, width
					- imgspacing - ListViewItem.display.DPADDING)) != -1) {
				if (focused && is_editable && type == ListViewItem.itemtype.LABEL) {
					// #expand g.setColor(%net.ayaslive.miniim.ui.core.list.listitemfactory.bgHover%);
					g.setColor(0x0099CC);

					// draw the advanced background
					// #ifdef net.ayaslive.miniim.ui.core.list.listitemfactory.bgShadeHover

					// Do special things if we are in the first line
					if (start == 0) {

						// draw rounded background
						// #expand g.fillRoundRect( x, y + ret, width, FONT_HEIGHT + ListViewItem.display.DPADDING, %net.ayaslive.miniim.ui.core.rounded_corner_radius%, %net.ayaslive.miniim.ui.core.rounded_corner_radius%);
						g.fillRoundRect(x, y + ret, width, FONT_HEIGHT + ListViewItem.display.DPADDING,
								4, 4);

						// draw the shadow
						// #expand g.setColor(%net.ayaslive.miniim.ui.core.list.listitemfactory.bgShadeHover%);
						g.setColor(0x00CCFF);

						// #expand g.fillRect( x + %net.ayaslive.miniim.ui.core.rounded_corner_radius%/2, y + ret + %net.ayaslive.miniim.ui.core.rounded_corner_radius%/2, width - %net.ayaslive.miniim.ui.core.rounded_corner_radius%, FONT_HEIGHT/2 + ListViewItem.display.PADDING - %net.ayaslive.miniim.ui.core.rounded_corner_radius%);
						g.fillRect(x + 4 / 2, y + ret + 4 / 2, width - 4,
								FONT_HEIGHT / 2 + ListViewItem.display.PADDING - 4);
					} else {
						g.fillRect(x, y + ret, width, FONT_HEIGHT + ListViewItem.display.DPADDING);
					}

					// #else
					//@
					//@         // draw plain background
					//@         g.fillRect( x, y + ret, width, FONT_HEIGHT + ListViewItem.display.DPADDING);
					// #endif

					// draw text
					// #expand g.setColor(%net.ayaslive.miniim.ui.core.list.listitemfactory.fgHover%);
					g.setColor(0xFFFFFF);
				}
				if (is_editable && target != null && type == ListViewItem.itemtype.LABEL) {
					parent.gi.registerScreenEvent(target, x + imgspacing + ListViewItem.display.PADDING
							, y + ret + ListViewItem.display.PADDING
							, x + imgspacing + ListViewItem.display.PADDING + ITEM_FONT.subStringWidth(&label, start, pos)
							, y + ret + ListViewItem.display.PADDING + FONT_HEIGHT);
				}
				//etxt xt = etxt.same_same(&text);
				etxt xt = etxt.same_same(&label);
				xt.shift(start);
				xt.trim_to_length(pos);
				print("Label:%s:%s\n", label.to_string(), xt.to_string());
				g.drawString(&xt
						, x + imgspacing + ListViewItem.display.PADDING
						,y + ret + ListViewItem.display.PADDING
						, 1000, width, Graphics.anchor.TOP | Graphics.anchor.LEFT);
				ret += FONT_HEIGHT + ListViewItem.display.DPADDING;
				start = pos;
				if (start == 0) {
					imgspacing = 0;
				}
				if (truncate_text_to_fit_width) {
					break;
				}
			}
			if (type != ListViewItem.itemtype.LABEL && type != ListViewItem.itemtype.CHECKBOX) {
				labelWidth = ITEM_FONT.subStringWidth(&label, 0, label.length());
				if (!wrapped && (labelWidth > width - ListViewItem.display.DPADDING)) {
					wrapped = false;
				}
				labelHeight = ret;
				labelWidth += ListViewItem.display.DPADDING;
			}
		}
		if (/*(text && text->len) || type == XULTB_LIST_ITEM_TEXT_INPUT*/ !text.is_empty_magical()) {

			if (wrapped) {

				lineCount = 0;
				//if (text->len) { /* when the string length is Zero */
					/* write the text in the next line */
					start = pos = 0;
					while ((pos = TextFormat.wrap_next(&text, ITEM_FONT, start, width
							- ListViewItem.display.DPADDING)) != -1 && lineCount < 3) {
						etxt xt = etxt.same_same(&text);
						xt.shift(start);
						xt.trim_to_length(pos);
						g.drawString(&xt, x + ListViewItem.display.PADDING, y
								+ ret + ListViewItem.display.PADDING, 1000, width, Graphics.anchor.TOP | Graphics.anchor.LEFT);
						ret += FONT_HEIGHT + ListViewItem.display.DPADDING;
						start = pos;
						lineCount++;
					}
				//}
				/* we are trying to show 3 lines always, not more not less */
				ret += (3 - lineCount) * (FONT_HEIGHT + ListViewItem.display.DPADDING);
				labelWidth = 0;
			} else {

				int imgWidth = 0;
				if (type == ListViewItem.itemtype.SELECTION) {
					imgWidth = ListViewItem.display.RESOLUTION;
				}

				pos = TextFormat.wrap_next(&text, ITEM_FONT, 0, width - labelWidth
						- ListViewItem.display.DPADDING - imgWidth - ListViewItem.display.DPADDING);
				if (pos != -1) {
					etxt xt = etxt.same_same(&text);
					xt.trim_to_length(pos);
					g.drawString(&xt, x + labelWidth + ListViewItem.display.PADDING,
							y + ListViewItem.display.PADDING, 1000, width, Graphics.anchor.TOP | Graphics.anchor.LEFT);
					if (pos < text.length()) {
						/* show an image at last to indicate that there are more data .. */
					}
				}
				if (type == ListViewItem.itemtype.SELECTION) {
					draw_selectionbox_icon(g, x + width - ListViewItem.display.RESOLUTION - ListViewItem.display.PADDING, y
							+ ListViewItem.display.PADDING, focused);
				}
				labelHeight = 0;

			}
		}
		// Draw the image
		if (img != null) {
			g.drawImage(img, x + ListViewItem.display.PADDING, y + ListViewItem.display.PADDING, Graphics.anchor.TOP | Graphics.anchor.LEFT);
		}

		if (type == ListViewItem.itemtype.CHECKBOX) {
			draw_checkbox_icon(g, x + ListViewItem.display.PADDING, y + ListViewItem.display.PADDING, focused);
		}

		// #expand g.setColor(focused?(isEditable?%net.ayaslive.miniim.ui.core.list.listitemfactory.boxHover%:%net.ayaslive.miniim.ui.core.list.listitemfactory.boxHoverInactive%):%net.ayaslive.miniim.ui.core.list.listitemfactory.box%);
		g.setColor(focused ? (is_editable ? 0x006699 : 0x999999) : 0xCCCCCC);

		if(is_editable && target != null) {
			parent.gi.registerScreenEvent(target, x + labelWidth, y + ListViewItem.display.PADDING, width,
					y + ret - ListViewItem.display.PADDING);
		}
		/* draw a square */
		if (type != ListViewItem.itemtype.CHECKBOX && (focused || type != ListViewItem.itemtype.LABEL)
		// #ifdef net.ayaslive.miniim.ui.core.list.listitemfactory.bgShadeHover
				&& !(focused && type == ListViewItem.itemtype.LABEL)
		// #endif
		) {
			//      #ifdef net.ayaslive.miniim.ui.core.rounded_corner_radius
			//      #expand g.drawRoundRect( x + labelWidth, y + labelHeight, width - labelWidth, ret - labelHeight, %net.ayaslive.miniim.ui.core.rounded_corner_radius%, %net.ayaslive.miniim.ui.core.rounded_corner_radius%);
			g.drawRoundRect(x + labelWidth, y + labelHeight, width - labelWidth,
					ret - labelHeight, 4, 4);
			//      #else
			//@     g.drawRect( x + labelWidth, y + labelHeight, width - labelWidth, ret - labelHeight);
			//      #endif
		}
		return ret;
	}
	
	public override bool doEdit(int flags, int key_code, int x, int y) {
		switch(type) {
			case ListViewItem.itemtype.TEXT_INPUT:
			{
				if((flags & GUIInput.eventType.KEYBOARD_EVENT) == 0) {
				  break;
				}
				bool changed = false;
				etxt dlg = etxt.stack(64);
				dlg.printf("Edit text field , key code:%d\n", key_code);
				Watchdog.logMsgDoNotUse(&dlg);
				// get current text
				etxt xt = etxt.stack(text.length()+1);
				xt.concat(&text);
				// handle special editing commands ..
				if((key_code == 0x7f) || (key_code == 8)) { // backspace
				  if(xt.length() > 0) {
					xt.trim_to_length(xt.length()-1);
				  }
				  changed = true;
				} else {
				  // TODO add appropriate restriction ..
				  if(is_printable(key_code)) {
					xt.concat_char((uchar)key_code);
					changed = true;
				  }
				}
				if(changed) {
				  update(&xt);
				}
				return true;
			}
			break;
			default:
			break;
		}
		return false;
	}
	public override int update(etxt*xt) {
		core.assert("It should be defined in the applet which is being edited" == null);
		return 0;
	}
	bool is_printable(int key_code) {
		return ((key_code >= 0x20) && (key_code <= 0x7E));
	}
	
	public ListViewItemComplex.createLabel(etxt*aLabel, onubodh.RawImage*aImg) {
		ListViewItemComplex.createLabelFull(aLabel, aImg, true, false, null);
	}

	public ListViewItemComplex.createLabelFull(etxt*aLabel, onubodh.RawImage*aImg
			, bool aChange_bg_on_focus, bool aTruncate_text_to_fit_width, Replicable?aTarget) {
		ListViewItemComplex.common();
		label = etxt.dup_etxt(aLabel);
		print("Created new label %s:%s\n", label.to_string(), aLabel.to_string());
		img = aImg;
		is_editable = aChange_bg_on_focus;
		target = aTarget;
		type = ListViewItem.itemtype.LABEL;
		truncate_text_to_fit_width = aTruncate_text_to_fit_width;
	}

	public ListViewItemComplex.createSelectionBox(etxt*aLabel, etxt*aText, bool aEditable) {
		ListViewItemComplex.common();
		label = etxt.dup_etxt(aLabel);
		text = etxt.dup_etxt(aText);
		is_editable = aEditable;
		type = ListViewItem.itemtype.SELECTION;
	}

	public ListViewItemComplex.createTextInputFull(etxt*aLabel, etxt*aText, bool aWrapped, bool aEditable) {
		ListViewItemComplex.common();
		label = etxt.dup_etxt(aLabel);
		text = etxt.dup_etxt(aText);
		wrapped = aWrapped;
		is_editable = aEditable;
		type = ListViewItem.itemtype.TEXT_INPUT;
	}

	public ListViewItemComplex.createTextInput(etxt*aLabel, etxt*aText) {
		ListViewItemComplex.createTextInputFull(aLabel, aText, false, true);
	}

	public ListViewItemComplex.createCheckboxFull(etxt*aLabel, bool aChecked, bool aEditable, bool aIsRadio) {
		ListViewItemComplex.common();
		label = etxt.dup_etxt(aLabel);
		checked = aChecked;
		is_editable = aEditable;
		type = ListViewItem.itemtype.CHECKBOX;
		img = null;
		is_radio = aIsRadio;
	}

	public ListViewItemComplex.createCheckbox(etxt*aLabel, bool aChecked, bool aEditable) {
		ListViewItemComplex.createCheckboxFull(aLabel, aChecked, aEditable, false);
	}

	public ListViewItemComplex.createRadioButton(etxt*aLabel, bool aChecked, bool aEditable) {
		ListViewItemComplex.createCheckboxFull(aLabel, aChecked, aEditable, true);
	}
}
