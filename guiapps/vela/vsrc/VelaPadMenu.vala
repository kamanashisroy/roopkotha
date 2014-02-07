using aroop;
using shotodol;
using roopkotha;
using roopkotha.vela;

/**
 * You can only trust the numbers. 
 * [-Maturity- 10]
 */
public class roopkotha.VelaPadMenu : Replicable {
	ArrayList<EventOwner> leftOptions;
	EventOwner rightOption;
	GUICoreImpl impl;
#if false
	PageView pg;
#else
	DocumentView lv;
#endif
	PageAppDocument emptyDoc;
	public VelaPadMenu() {
		leftOptions = ArrayList<EventOwner>();
		etxt rightOptionText = etxt.from_static("Quit");
		rightOption = new EventOwner(this, &rightOptionText);
		etxt openFileText = etxt.from_static("Open");
		EventOwner openFile = new EventOwner(this, &openFileText);
		leftOptions.set(0, openFile);
		guiinit();
	}
	void guiinit() {
		impl = new GUICoreImpl();
#if false
		pg = new PageView();	
#else
		etxt title = etxt.from_static("Roopkotha");
		etxt dc = etxt.from_static("quit");
		lv = new DocumentView(&title, &dc);	
#endif
		emptyDoc = new PageAppDocument();
		/*etxt elem = etxt.from_static("Write something here..");
		emptyDoc.addLine(&elem);*/
#if false
		pg.setDocument(emptyDoc, 0);
		pg.show();
#else
		lv.setDocument(emptyDoc, 0);
		lv.show();
#endif
		MainTurbine.gearup(impl);
	}
	protected void show(PageAppDocument pd) {
#if false
		pg.setDocument(pd, 0);
		pg.showFull(&leftOptions, rightOption);
#else
		lv.setDocument(pd, 0);
		lv.showFull(&leftOptions, rightOption);
#endif
	}
}
