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

public class roopkotha.HTMLMarkupContent : FormattedContent {
	txt data;
	enum XMLCapsule {
		TAG_START = 100, // "<"
		TAG_END, // ">"
	}

	public HTMLMarkupContent(etxt*asciiData) {
		base();
		data = new txt.memcopy_etxt(asciiData);
		cType = ContentType.FormattedContent;
		print("FormattedContent:%s\n", data.to_string());
	}

	public override int getText(etxt*tData) {
		tData.concat(data);
		return 0;
	}

	public override bool isFocused() {
		xultb_str_t*focused = xultb_ml_get_attribute_value(elem, "focused");
		if(focused && xultb_str_equals_static(focused, "yes")) {
			return true;
		}
		return false;
	}

	public override bool isActive() {
		xultb_str_t*active = xultb_ml_get_attribute_value(elem, "active");
		if(active && xultb_str_equals_static(active, "yes")) {
			return true;
		}
		return false;
	}

	public void format(etxt*extract, FormattedTextCapsule*cap) {
		// sanity check
		if(extract.charAt(0) != XMLCapsule.TAG_START || extract.charAt(extract.length()-1) != XMLCapsule.TAG_END) {
			cap.textType = FormattedTextCapsule.FormattedTextType.UNKNOWN;
			return;
		}
		cap.textType = extract.charAt(1);
	}

	public void peelCapsule(etxt*extract, etxt*output) {
		// sanity check
		if(extract.charAt(0) != XMLCapsule.TAG_START || extract.charAt(extract.length()-1) != XMLCapsule.TAG_END) {
			cap.textType = FormattedTextCapsule.FormattedTextType.UNKNOWN;
			return;
		}
		int nextCapsule = 0;
		int len = extract.length();
		for (i = 0;i<len; i++) {
			if(extract.charAt(i) == XMLCapsule.TAG_END) {
				nextCapsule = i;
				break;
			}
		}
		if(nextCapsule == 0 || nextCapsule == len - 1) { // There is no internal capsule
			return;
		}
		int nextCapsuleEnd = 0;
		for (i = len-1;i; i--) {
			if(extract.charAt(i) == XMLCapsule.TAG_START) {
				nextCapsuleEnd = i;
				break;
			}
		}
		if(nextCapsuleEnd > nextCapsule) { // There is no internal capsule
			return;
		}
		*output = etxt.same_same(extract);
		output.trim(nextCapsuleEnd-1);
		output.shift(nextCapsule+1);
	}

	public override int getNextChild(FormattedTextCapsule*node, FormattedTextCapsule*child) {
		core.assert(child != null);
		if(node == null) {
			format(extract, child);
		}
		return 0;
	}
}


