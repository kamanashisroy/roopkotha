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

public class roopkotha.vela.HTMLMarkupContent : FormattedContent {
	XMLParser parser;
	WordMap map;
	enum XMLCapsule {
		TAG_START = 100, // "<"
		TAG_END, // ">"
	}

	public HTMLMarkupContent(etxt*asciiData) {
		base();
		cType = ContentType.FormattedContent;
		parser = new XMLParser();
		map = WordMap();
		map.extract.buffer(asciiData.length());
		map.source = etxt.same_same(asciiData);
		map.map.buffer(asciiData.length());
		parser.transform(&map);
		print("FormattedContent:%s\n", data.to_string());
	}

	~HTMLMarkupContent() {
		map.destroy();
	}

	public override int getText(etxt*tData) {
		tData.concat(data);
		return 0;
	}

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
			xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.content.length(), &cap.content);
			convoy(&cap);
		} else {
			// TODO match the xit.nextTag.to_string() with B/BR/A/BIG/SMALL/U/P/A ...
		}
	}	

	public override int traverseCapsules(VisitAugmentedContent visitCapsule) {
		convoy = visitCapsule;
		parser.traversePreorder(&map, 1, traverseCB);
	}
}


