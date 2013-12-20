using aroop;
using shotodol;
using roopkotha;

public class roopkotha.WritePadMenu : Replicable {
	ArrayList<txt> leftOptions;
	txt rightOption;
	GUICoreImpl impl;
	DocumentView lv;
	PlainDocument emptyDoc;
	public WritePadMenu() {
		leftOptions = ArrayList<txt>();
		rightOption = new txt.from_static("Quit");
		txt openFile = new txt.from_static("Open");
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
