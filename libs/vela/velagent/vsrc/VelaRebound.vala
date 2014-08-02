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
public class roopkotha.velagent.VelaRebound : Replicable {
	PageWindow?page;
	RoopDocument?content;
	VelaResourceHandler?handler;
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

	public VelaRebound() {
		BACK_ACTION = new xtring.set_static_string("Back");
		VELA = new xtring.set_static_string("Vela");
		content = null;
		stack = ArrayList<xtring>(4);
		images = ArrayList<onubodh.RawImage>(4);
		isLoadingPage = false;
		isGoingBack= false;
		baseUrl = null;
		currentUrl = null;
		page = null;
		handler = null;
	}

	~VelaRebound() {
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
		cmd.concat(&paction.action);
		velaxecute(&cmd, false);
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

	public void onContentDisplay(VelaResource id, Replicable content) {
		extring entry = extring.set_static_string("vela/onContentDisplay");
		Plugin.swarm(&entry, &id.url, null);
	}

	public void onContentReady(VelaResource id, Replicable content) {
		Watchdog.logString(core.sourceFileName(), core.sourceLineNo(), 1, "VelaRebound:New content.. ...\n");
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
	public void plugPage(PageWindow?view) {
		page = view;
		if(page == null) return; // TODO retract all the event handler when page is null
		page.setActionCB(onWindowEvent);
		page.setPageEvent(onPageEvent);
		page.setImageLoader(getImage);
	}

	public void plugHandler(VelaResourceHandler?givenHandler) {
		handler = givenHandler;
		if(handler == null) return; // TODO set all the callbacks to null when the handler is null
		handler.setContentCallback(onContentReady);
		handler.setContentErrorCallback(onResourceError);
	}
}

/** @} */
