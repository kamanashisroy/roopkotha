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
using roopkotha.gui;
using roopkotha.doc;
using roopkotha.vela;

/** \addtogroup vela
 *  @{
 */
/**
 * You can only trust the numbers. 
 * [-Maturity- 0]
 */

public class roopkotha.vela.PageMenu : roopkotha.doc.DocumentView {
	XMLParser parser;
	WordMap map;
	EventOwner?rightOption;
	ArrayList<EventOwner> leftOptions;
	public PageMenu(etxt*gTitle, etxt*gAbout) {
		base(gTitle, gAbout);
		parser = new XMLParser();
		map = WordMap();
		rightOption = null;
		leftOptions = ArrayList<EventOwner>();
	}

	~PageMenu() {
		map.destroy();
	}

	public int setMenu(etxt*menuML) {
		// parse the xml and show the menu
		map.extract.buffer(menuML.length());
		map.source = etxt.dup_etxt(menuML);
		map.map.buffer(menuML.length());
		parser.transform(&map);

		// traverse
		int count = 0;
		print("Traversing ..\n");
		parser.traversePreorder(&map, 100, (xit) => {
			print("..\n");
#if false
			if(!xit.nextIsText) {
				return;
			}
			print("Traversing text capsules .. \n");
#if LOW_MEMORY
			etxt content = etxt.stack(128);
#else
			etxt content = etxt.stack(1024);
#endif
			xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.content.length(), &content);
			content.zero_terminate();
			print("Traversing text capsules .. %s\n", content.to_string());
			if(content.is_empty()) {
				return;
			}
			print("Setting new action for .. %s\n", content.to_string());
			EventOwner x = new EventOwner(this, &content);
			if(rightOption == null ) {
				rightOption = x;
				return;
			}
			leftOptions.set(count, x);
			count++;
			print("Done.. %d\n", count);
#else
		print(".. node :\n");
		if(xit.nextIsText) {
			etxt tcontent = etxt.stack(256);
			xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.content.length(), &tcontent);
			print("Text\t\t- pos:%d,clen:%d,text content:%s\n", xit.pos, xit.content.length(), tcontent.to_string());
		} else {
			print("pos:%d,clen:%d,tag:%s\n", xit.pos, xit.content.length(), xit.nextTag.to_string());
			etxt tcontent = etxt.stack(256);
			xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.content.length(), &tcontent);
			print("Content\t\t- pos:%d,clen:%d,content:%s\n", xit.pos, xit.content.length(), tcontent.to_string());
			//xit.m.getSourceReference(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.attrs.length(), &tcontent);
			//print("Attrs\t\t- pos:%d,clen:%d,attr content:%s\n", xit.pos, xit.attrs.length(), tcontent.to_string());
			etxt attrKey = etxt.EMPTY();
			etxt attrVal = etxt.EMPTY();
			while(xit.nextAttr(&attrKey, &attrVal)) {
				print("key:[%s],val:[%s]\n", attrKey.to_string(), attrVal.to_string());
			}
		}
#endif
			return;
		});
		print("All Done.. %d\n", count);
		//xit.destroy();
		showFull(&leftOptions, rightOption);
		return 0;
	}
#if false
	public override void show() {
		showFull(&leftOptions, rightOption);
	}		
#endif
}
/** @} */
