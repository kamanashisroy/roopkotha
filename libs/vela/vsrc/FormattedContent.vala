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

struct roopkotha.FormattedTextCapsule {
	enum FormattedTextType {
		BR,
		IMG,
		B,
		UNKNOWN,
	}
	FormattedTextType textType;
	
}
public class roopkotha.FormattedContent : AugmentedContent {
	txt data;

	public FormattedContent(etxt*asciiData) {
		base();
		data = new txt.memcopy_etxt(asciiData);
		cType = ContentType.FormattedContent;
		print("FormattedContent:%s\n", data.to_string());
	}

	public override int getText(etxt*tData) {
		tData.concat(data);
		return 0;
	}
}
