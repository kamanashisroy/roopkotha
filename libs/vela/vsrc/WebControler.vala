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

/**
 * \ingroup doc
 * \defgroup vela A browser interface on top of our gui.
 */

/** \addtogroup vela
 *  @{
 */
public class roopkotha.vela.WebControler : Replicable {
	PageView page;
	RoopDocument?content;
	WebResourceLoader loader;
	//MediaLoader ml;
	//WebEventListener el;
	//WebActionListener al;
	ArrayList<txt>stack;
	ArrayList<onubodh.RawImage> images;
	bool isLoadingPage;
	bool isGoingBack;
	txt currentUrl;
	txt baseUrl;
	PageAppDocument doc;
	txt BACK_ACTION;
	txt VELA;

	public WebControler(PageView view, WebResourceLoader rl) {
		BACK_ACTION = new txt.from_static("Back");
		VELA = new txt.from_static("Vela");
		page = view;
		content = null;
		page.setActionCB(onWindowEvent);
		page.setPageEvent(onPageEvent);
		page.setImageLoader(getImage);
		stack = ArrayList<txt>(4);
		images = ArrayList<onubodh.RawImage>(4);
		isLoadingPage = false;
		isGoingBack= false;
		baseUrl = currentUrl = null;
		loader = rl;
		loader.setContentCallback(onContentReady);
		loader.setContentErrorCallback(onResourceError);
	}

	~WebControler() {
		images.destroy();
		stack.destroy();
	}

#if false
int xultb_list_item_attr_is_positive(struct xultb_ml_node*elem, const char*response) {
	xultb_str_t*value = xultb_ml_get_attribute_value(elem, response);
	return (value && xultb_str_equals_static(value, "y"));//(value && value->len == 1 && *(value->str) == 'y');
}
#endif

#if false
	int getDefaultSelectedItem(RoopDocument aDoc) {
		int ret = 0;
		for(i=0;i>0;i++) {
			opp_at_ncode2(s, struct xultb_ml_node*, (&node->children), i,
				if (s->elem.type == XULTB_ELEMENT_NODE && xultb_list_item_attr_is_positive(s, "s")) {
					ret = i;
					i = -2;
				}
			) else {
				break;
			}
		}
		return ret;
	}
#endif

	public bool pushWrapperFull(WebResource id, bool back) {
		if (isLoadingPage) { // check if we are on action ..
			print("We are still loading a page, we cannot perform other actions ..\n");
			return false;
		}
#if false
		Window.pushBalloon("Loading ..", null, hashCode(), 100000000);
#endif

		// web->images.clear(); -> clear ..
		isLoadingPage = true;
		isGoingBack = back;

		loader.request(id);
		return true;
	}

	public bool pushWrapper(etxt*url, WebVariables?vars, bool back) {
		return pushWrapperFull(new WebResource(baseUrl, url, doc, vars), back);
	}

	public void onWindowEvent(EventOwner action) {
		etxt label = etxt.EMPTY();
		action.getLabel(&label);
		print("Action is %s\n", label.to_string());

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
					pushWrapper(&appAction, null, false);
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
				pushWrapper(last, null, true);
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
				pushWrapper(url, page.getVariables(), false);
			}
			break;
		}
#endif
	}

#if false
	public void onPageEvent(struct xultb_ml_node*elem, enum markup_event_type type) {
		push_wrapper_impl(cb_data, xultb_ml_get_attribute_value(elem, "href")
				, xultb_get_web_variables(((struct xultb_web_controler*)cb_data)->mlist->root), false);
	}
#else
	public void onPageEvent(etxt*target) {
		pushWrapper(target, page.getVariables(), false);
	}
#endif

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

	//#define WEB_ASSERT_RETURN(x,y,z) if(!x) {SYNC_LOG(SYNC_VERB, y); return z;}
	public void onContentReady(WebResource id, Replicable content) {
#if false
		// \todo set menu command ..
		if(id->type == XULTB_RESOURCE_IMG) {
	#if false
			Window.pushBalloon(null, null, hashCode(), 0);
	#endif
			SYNC_LOG(SYNC_VERB, "handleContent()\t\t[+]Image -> %s\n", id->url->str);
			OPP_ALLOC2(&web->images, content);
			xultb_guicore_set_dirty(&web->mlist->super_data.super_data);
			return;
		}
		struct xultb_ml_node*root = content;
		struct xultb_ml_node*x = xultb_ml_get_node(root, "x");
		WEB_ASSERT_RETURN(x, "no x\n",);
		struct xultb_ml_node*list = xultb_ml_get_node(x, "ls");
		WEB_ASSERT_RETURN(list, "no ls\n",);
	#if 0
		Window.pushBalloon(null, null, hashCode(), 0);
	#endif
	#if 0
		synchronized (this) {
	#endif
		if(web->current_url && !web->isGoingBack) {
			if(xultb_strcmp(web->current_url, id->url)) {
				SYNC_LOG(SYNC_VERB, "handleContent()\t\t%s\t\t[+]\n", web->current_url->str);
				opp_indexed_list_set(&web->stack, OPP_FACTORY_USE_COUNT(&web->stack), web->current_url);
			} else {
				SYNC_LOG(SYNC_VERB, "handleContent()\t\t%s\t\t[*]\n", web->current_url->str);
			}
		} else if(web->isGoingBack){
			// SYNC_LOG(SYNC_VERB, "handleContent()\t\t" + stack.lastElement() + "\t\t[-]");
			opp_indexed_list_set(&web->stack,OPP_FACTORY_USE_COUNT(&web->stack)-1, NULL);
		}
		OPPUNREF(web->current_url);
		web->current_url = OPPREF(id->url);

		// save the current doc and base
		web->root = OPPREF(root);
		OPPUNREF(web->base);
		web->base = xultb_str_alloc(NULL, 128, NULL, 0);

		xultb_str_t*url = id->url;
		int last = xultb_str_indexof_char(url, '/');
		if(last == -1) {
	//		xultb_str_cat(web->base, url);
	//		xultb_str_cat_char(web->base, '/');
		} else {
			xultb_str_cat(web->base, id->url);
			web->base->len = last+2;
			SYNC_LOG(SYNC_VERB, "Web controller base(%d):%s\n", web->base->len, web->base->str);
		}
	#if 0
		}
		reset_menu(web);
	#endif
		int i = 0, j = 0, k = 0;
		struct xultb_ml_node*menu,*cmd;
		web->mlist->right_menu = NULL;
		if (OPP_FACTORY_USE_COUNT(&web->stack)) {
			web->mlist->right_menu = BACK_ACTION;
		}
		for(i=0;;i++) {
			opp_at_ncode(menu, (&x->children), i,
				if(menu->elem.type == XULTB_ELEMENT_NODE && xultb_str_equals_static(menu->name, "m")) {
					for(j = 0;; j++) {
					opp_at_ncode(cmd, (&menu->children), j,
						xultb_str_t*target = xultb_ml_get_text(cmd);
						if(target) {
							if(!web->mlist->right_menu) {
								GUI_LOG("Adding right command %s\n", target->str);
								web->mlist->right_menu = target;
							} else {
								GUI_LOG("Adding command %s\n", target->str);
								opp_indexed_list_set(&web->mlist->left_menu, k++, target);
							}
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
	#if 0
		String tmp = x.getAttributeValue("c");
		long cacheTimeout = (tmp != null)?(Integer.parseInt(tmp)*1000):-1;
		// See if we can cache it
		if(cacheTimeout != -1) {

			// see if it already cached
			if(!Document.exists(MINI_WEB, url)) {

				SimpleLogger.debug(this, "handleContent()\t\t[######] <<  " + url);
				// cache it
				doc.store(MINI_WEB, url, false, cacheTimeout);
			}

		}
	#endif
		// SYNC_LOG(SYNC_ERROR, "handleContent(): no commands\n");
		xultb_str_t*title = xultb_ml_get_attribute_value(list, "t");
		if(!title) {
			title = MINI_WEB;
		}
		web->mlist->super_data.super_data.vtable->set_title(&web->mlist->super_data.super_data, title);
		web->mlist->vtable->set_node(web->mlist, list, get_default_selected_item(list));
	//	web->mlist->super_data.super_data.vtable->show_full(&web->mlist->super_data.super_data
	//			, left_menu, right_menu);
		clearFlags(web);
#endif
	}

	public void onResourceError(WebResource id, int code, etxt*reason) {
		clearFlags();
		print("onResourceError()\n");
		if(id.tp == WebResource.Type.DOCUMENT) {
			// what to do ??
		} else {
			// images.put(url, Image.createImage("/ui/error.png"));
		}
#if false
		Window.pushBalloon("Error ..", null, hashCode(), 2000);
#endif
	}

}

/** @} */
