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
using roopkotha.doc;
using roopkotha.vela;

public enum roopkotha.vela.FormattedTextType {
		BR,
		IMG,
		B,
		I,
		BIG,
		SMALL,
		STRONG,
		EM,
		U,
		P,
		A,
		PLAIN,
		UNKNOWN,
}

public struct roopkotha.vela.FormattedTextCapsule {
	
	public roopkotha.vela.FormattedTextType textType;
	public etxt content;
	public etxt hyperLink;
	public bool isFocused;
	public bool isActive;
	public FormattedTextCapsule() {
		textType = FormattedTextType.PLAIN;
		content = etxt.EMPTY();
		hyperLink = etxt.EMPTY();
		isFocused = false;
	}
}

public delegate int roopkotha.vela.VisitAugmentedContent(FormattedTextCapsule*capsule);

public abstract class roopkotha.vela.FormattedContent : roopkotha.doc.AugmentedContent {
	txt data;

	public FormattedContent(etxt*asciiData) {
		base();
		data = new txt.memcopy_etxt(asciiData);
		cType = AugmentedContent.ContentType.FORMATTED_CONTENT;
		print("FormattedContent:%s\n", data.to_string());
	}

	public override void getText(etxt*tData) {
		tData.concat(data);
	}
	public abstract void traverseCapsulesInit();
	public abstract int traverseCapsules(VisitAugmentedContent visitCapsule);
}
