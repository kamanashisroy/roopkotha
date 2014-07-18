using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.doc;
using roopkotha.vela;

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
	ArrayList<xtring>stack;
	ArrayList<onubodh.RawImage> images;
	bool isLoadingPage;
	bool isGoingBack;
	xtring?currentUrl;
	xtring?baseUrl;
	RoopDocument doc;
	xtring BACK_ACTION;
	xtring VELA;

	public Velagent(VelaResourceHandler rl) {
		BACK_ACTION = new xtring.set_static_string("Back");
		VELA = new xtring.set_static_string("Vela");
		content = null;
		stack = ArrayList<xtring>(4);
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
			extring dlg = extring.stack(128);
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

	public bool velaxecute(extring*url, bool back) {
		return velaxecuteFull(new VelaResource(null, url, doc), back);
	}

	public void onWindowEvent(EventOwner action) {
		PageEventOwner paction = (PageEventOwner)action;

		extring dbg = extring.stack(128);
		dbg.printf("Action is %s\n", paction.action.to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 5, Watchdog.WatchdogSeverity.DEBUG, 0, 0, &dbg);

		extring cmd = extring.stack(128);
		//cmd.concat_string("velaxecute://");
		cmd.concat(&paction.action);
		velaxecute(&cmd, false);
#if false
		// Normal mode ..
		//if(action.equals(page.default_command)) {
		Replicable?src = action.getSource();
		if(src == page) {
			// GUI_INPUT_LOG("item action !\n");
			AugmentedContent?content = (AugmentedContent)page.getSelected();
			extring appAction = extring();
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

	public void onPageEvent(extring*target) {
		print("Page event %s\n", target.to_string());
		velaxecute(target, false);
	}

	onubodh.RawImage?getImage(extring*imgAddr) {
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
			RoopDocument rd = (RoopDocument)content;
			onContentDisplay(id, rd);
			page.setDocument(rd, 0);
			page.show();
			clearFlags();
		}
	}

	public void onResourceError(VelaResource id, int code, extring*reason) {
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
	void traverseMenu(onubodh.XMLIterator*xit) {
		if(xit.nextIsText) {
			return;
		}
		extring key = extring.stack(128);
		extring href = extring();
		href.buffer(128);
		extring label = extring();
		label.buffer(32);
		extring attrKey = extring();
		extring attrVal = extring();
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
	public int plugMenu(extring*menuML) {
		onubodh.XMLParser parser = new onubodh.XMLParser();
		onubodh.WordMap map = onubodh.WordMap();
		// parse the xml and show the menu
		map.kernel.buffer(menuML.length());
		map.source = extring.copy_on_demand(menuML);
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
