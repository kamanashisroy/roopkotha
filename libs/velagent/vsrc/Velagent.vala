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
using roopkotha.velatml;

/**
 * \ingroup vela
 * \defgroup vela Action dispatcher for vela browser
 */

/** \addtogroup velagent
 *  @{
 */
public class roopkotha.velagent.Velagent : Replicable {
	PageView?page;
	RoopDocument?content;
	VelaResourceHandler handler;
	//MediaHandler ml;
	//WebEventListener el;
	//WebActionListener al;
	ArrayList<txt>stack;
	ArrayList<onubodh.RawImage> images;
	bool isLoadingPage;
	bool isGoingBack;
	txt?currentUrl;
	txt?baseUrl;
	RoopDocument doc;
	txt BACK_ACTION;
	txt VELA;

	public Velagent(VelaResourceHandler rl) {
		BACK_ACTION = new txt.from_static("Back");
		VELA = new txt.from_static("Vela");
		content = null;
		stack = ArrayList<txt>(4);
		images = ArrayList<onubodh.RawImage>(4);
		isLoadingPage = false;
		isGoingBack= false;
		baseUrl = null;
		currentUrl = null;
		handler = rl;
		handler.setContentCallback(onContentReady);
		handler.setContentErrorCallback(onResourceError);
		page = null;
	}

	~Velagent() {
		images.destroy();
		stack.destroy();
	}

	public bool velaxecuteFull(VelaResource id, bool back) {
		if (isLoadingPage) { // check if we are on action ..
			etxt dlg = etxt.stack(128);
			dlg.printf("Busy, cannot load reasource:%s\n", id.url.to_string());
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 1, Watchdog.WatchdogSeverity.ALERT, 0, 0, &dlg);
			return false;
		}
#if false
		Window.pushBalloon("Loading ..", null, hashCode(), 100000000);
#else
		print("Loading resource ..\n");
#endif

		// web->images.clear(); -> clear ..
		isLoadingPage = true;
		isGoingBack = back;

		handler.request(id);
		return true;
	}

	public bool velaxecute(etxt*url, bool back) {
		return velaxecuteFull(new VelaResource(null, url, doc), back);
	}

	public void onWindowEvent(EventOwner action) {
		PageEventOwner paction = (PageEventOwner)action;

		etxt dbg = etxt.stack(128);
		dbg.printf("Action is %s\n", paction.action.to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 5, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dbg);

		etxt cmd = etxt.stack(128);
		cmd.printf("velaxecute://");
		cmd.concat(&paction.action);
		velaxecute(&cmd, false);
#if false
		// Normal mode ..
		//if(action.equals(page.default_command)) {
		Replicable?src = action.getSource();
		if(src == page) {
			// GUI_INPUT_LOG("item action !\n");
			AugmentedContent?content = (AugmentedContent)page.getSelected();
			etxt appAction = etxt.EMPTY();
			if(content != null) {
				content.getAction(&appAction);
				if(!appAction.is_empty()) {
					velaxecute(&appAction, false);
					return;
				}
			}
		} else if(src == BACK_ACTION) {
	//		GUI_INPUT_LOG("Back back back .. \n");
			core.assert("Stack is unimplemented\n" == null);
#if false
			xultb_str_t*last = opp_indexed_list_get(&web->stack, OPP_FACTORY_USE_COUNT(&web->stack) - 1);
			if(last) {
	//			GUI_INPUT_LOG("It should render %s\n", last->str);
				OPPUNREF(web->base);
				velaxecute(last, true);
				OPPUNREF(last);
				return;
			}
#endif
		}

		// TODO specialize the target action
#if false
		// see if the action is menu command
		while(action) {
			struct xultb_ml_node*x = xultb_ml_get_node(web->root, "x");
			if(!x) {
				break;
			}
			int i = 0, j = 0;
			struct xultb_ml_node*menu,*cmd;
			xultb_str_t*url = NULL;
			for(i=0;;i++) {
				opp_at_ncode(menu, (&x->children), i,
					if(menu->elem.type == XULTB_ELEMENT_NODE && xultb_str_equals_static(menu->name, "m")) {
						GUI_INPUT_LOG("We are working on menu\n");
						for(j = 0;j>=0; j++) {
							opp_at_ncode(cmd, (&menu->children), j,
								xultb_str_t*target = xultb_ml_get_text(cmd);
								GUI_INPUT_LOG("Menu:%s,Action:%s\n", target?target->str:"NULL",action->str);
								if(target == action) {
									url = xultb_ml_get_attribute_value(cmd, "href");
									j = -2;
								}
							) else {
								break;
							}
						}
					}
				) else {
					break;
				}
			}
			if(url) {
				velaxecute(url, false);
			}
			break;
		}
#endif
#endif
	}

	public void onPageEvent(etxt*target) {
		print("Page event");
		velaxecute(target, false);
	}

	onubodh.RawImage?getImage(etxt*imgAddr) {
		// TODO fill me
		return null;
	}

	public void clearFlags() {
		isLoadingPage = false;
		isGoingBack = false;
#if false
		Window.pushBalloon(null, null, hashCode(), 0);
#endif
	}

	public virtual void onContentDisplay(VelaResource id, Replicable content) {
	}

	public void onContentReady(VelaResource id, Replicable content) {
		Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 1, "Velagent:New content.. ...\n");
		if(id.tp == VelaResource.Type.DOCUMENT) {
			VTMLDocument pd = new VTMLDocument();
			txt tcontent = (txt)content;
			pd.spellChunk(tcontent);
			onContentDisplay(id, content);
			page.setDocument(pd, 0);
			page.show();
			clearFlags();
		}
	}

	public void onResourceError(VelaResource id, int code, etxt*reason) {
		clearFlags();
		print("onResourceError()\n");
		if(id.tp == VelaResource.Type.DOCUMENT) {
			// what to do ??
		} else {
			// images.put(url, Image.createImage("/ui/error.png"));
		}
#if false
		Window.pushBalloon("Error ..", null, hashCode(), 2000);
#endif
	}
	public void plugPage(PageView view) {
		page = view;
		page.setActionCB(onWindowEvent);
		page.setPageEvent(onPageEvent);
		page.setImageLoader(getImage);
	}
	public void traverseMenu(onubodh.XMLIterator*xit) {
		if(xit.nextIsText) {
			return;
		}
		etxt key = etxt.stack(128);
		etxt href = etxt.EMPTY();
		href.buffer(128);
		etxt label = etxt.EMPTY();
		label.buffer(32);
		etxt attrKey = etxt.EMPTY();
		etxt attrVal = etxt.EMPTY();
		while(xit.nextAttr(&attrKey, &attrVal)) {
			// trim ..
			key.trim_to_length(0);
			key.concat(&attrKey);
			key.zero_terminate();
			while(key.char_at(0) == ' ') {key.shift(1);}
			if(key.equals_string("href")) {
				href.concat(&attrVal);
			} else if(key.equals_string("label")) {
				label.concat(&attrVal);
			}
		}
		while(href.char_at(0) == '"') {href.shift(1);}
		while(href.char_at(href.length()-1) == '"') {href.trim_to_length(href.length()-1);}
		href.zero_terminate();
		if(href.is_empty()) {
			return;
		}
		while(label.char_at(0) == ' ') {label.shift(1);}
		while(label.char_at(0) == '"') {label.shift(1);}
		while(label.char_at(label.length()-1) == '"') {label.trim_to_length(label.length()-1);}
		label.zero_terminate();
		if(label.is_empty()) {
			return;
		}
		PageEventOwner x = new PageEventOwner(&href, &label, handler);
		page.addMenu(x);
		return;
	}
	public int plugMenu(etxt*menuML) {
		onubodh.XMLParser parser = new onubodh.XMLParser();
		onubodh.WordMap map = onubodh.WordMap();
		// parse the xml and show the menu
		map.kernel.buffer(menuML.length());
		map.source = etxt.dup_etxt(menuML);
		map.map.buffer(menuML.length());
		parser.transform(&map);

		page.resetMenu();

		// traverse
		parser.traversePreorder(&map, 100, traverseMenu);
		page.finalizeMenu();
		map.destroy();
		return 0;
	}
}

/** @} */
