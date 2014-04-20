using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.doc;

public class roopkotha.app.WritePadMenu : Replicable {
	ArrayList<EventOwner> leftOptions;
	EventOwner rightOption;
	GUICoreImpl impl;
	DocumentView lv;
	PlainDocument emptyDoc;
	public WritePadMenu() {
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
		etxt title = etxt.from_static("Roopkotha");
		etxt dc = etxt.from_static("quit");
		lv = new DocumentView(&title, &dc);	
		emptyDoc = new PlainDocument();
		etxt elem = etxt.from_static("Write something here..");
		emptyDoc.addLine(&elem);
		lv.setDocument(emptyDoc, 0);
		lv.show();
		MainTurbine.gearup(impl);
	}
	protected void show(PlainDocument pd) {
		lv.setDocument(pd, 0);
		lv.showFull(&leftOptions, rightOption);
	}
}
