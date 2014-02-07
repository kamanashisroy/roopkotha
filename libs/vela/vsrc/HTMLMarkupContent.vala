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
using onubodh;
using roopkotha;
using roopkotha.vela;

/**
 * You can only trust the numbers. 
 * [-Maturity- 10]
 */
public class roopkotha.vela.HTMLMarkupContent : FormattedContent {
	XMLParser parser;
	WordMap map;

	public HTMLMarkupContent(etxt*asciiData) {
		base(asciiData);
		parser = new XMLParser();
		map = WordMap();
		map.extract.buffer(asciiData.length());
		map.source = etxt.same_same(asciiData);
		map.map.buffer(asciiData.length());
		parser.transform(&map);
		print("FormattedContent:%s\n", asciiData.to_string());
	}

	~HTMLMarkupContent() {
		map.destroy();
	}

#if false
	public override void getText(etxt*tData) {
		tData.concat(data);
	}
#endif

	public override bool isFocused() {
#if false
		xultb_str_t*focused = xultb_ml_get_attribute_value(elem, "focused");
		if(focused && xultb_str_equals_static(focused, "yes")) {
			return true;
		}
#endif
		return false;
	}

	public override bool isActive() {
#if false
		xultb_str_t*active = xultb_ml_get_attribute_value(elem, "active");
		if(active && xultb_str_equals_static(active, "yes")) {
			return true;
		}
#endif
		return false;
	}

	VisitAugmentedContent convoy;
	void traverseCB(XMLIterator*xit) {
		FormattedTextCapsule cap = FormattedTextCapsule();
		if(xit.nextIsText) {
			cap.content = etxt.stack(128);
			cap.textType = FormattedTextType.PLAIN;
			xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.content.length(), &cap.content);
			convoy(&cap);
		} else {
			if(xit.nextTag.equals_static_string("B")) {
				cap.textType = FormattedTextType.B;
			} else if(xit.nextTag.equals_static_string("BR")) {
				cap.textType = FormattedTextType.BR;
			} else if(xit.nextTag.equals_static_string("IMG")) {
				cap.textType = FormattedTextType.IMG;
			} else if(xit.nextTag.equals_static_string("I")) {
				cap.textType = FormattedTextType.I;
			} else if(xit.nextTag.equals_static_string("BIG")) {
				cap.textType = FormattedTextType.BIG;
			} else if(xit.nextTag.equals_static_string("SMALL")) {
				cap.textType = FormattedTextType.SMALL;
			} else if(xit.nextTag.equals_static_string("STRONG")) {
				cap.textType = FormattedTextType.STRONG;
			} else if(xit.nextTag.equals_static_string("EM")) {
				cap.textType = FormattedTextType.EM;
			} else if(xit.nextTag.equals_static_string("U")) {
				cap.textType = FormattedTextType.U;
			} else if(xit.nextTag.equals_static_string("P")) {
				cap.textType = FormattedTextType.P;
			} else if(xit.nextTag.equals_static_string("A")) {
				cap.textType = FormattedTextType.A;
			} else {
				cap.textType = FormattedTextType.UNKNOWN;
			}
			etxt attrKey = etxt.EMPTY();
      etxt attrVal = etxt.EMPTY();
      while(xit.nextAttr(&attrKey, &attrVal)) {
				// TODO trim key and value
        print("key:[%s],val:[%s]\n", attrKey.to_string(), attrVal.to_string());
				if(attrKey.equals_static_string("href")) {
					cap.hyperLink.destroy();
					cap.hyperLink = etxt.same_same(&attrVal);
				} else if(attrKey.equals_static_string("f")) {
					if(attrVal.equals_static_string("true"))	{
						cap.isFocused = true;
					}
				} else if(attrKey.equals_static_string("a")) {
					if(attrVal.equals_static_string("true"))	{
						cap.isActive = true;
					}
				}
      }
			convoy(&cap);
		}
	}	

	public override int traverseCapsules(VisitAugmentedContent visitCapsule) {
		convoy = visitCapsule;
		parser.traversePreorder(&map, 1, traverseCB);
		return 0;
	}

#if false
	int update(struct xultb_list_item*item, xultb_str_t*text) {
		struct xultb_ml_node*node = item->target;
		SYNC_ASSERT(node);
		xultb_str_t*new_text = OPPREF(text);
		OPPUNREF(node->elem.content);
		GUI_INPUT_LOG("setting new text %s\n", new_text->str);
		node->elem.content = new_text;
		return 0;
	}
#endif
}


