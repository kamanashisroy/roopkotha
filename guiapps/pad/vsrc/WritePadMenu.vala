using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.doc;

/** \addtogroup padapp
 *  @{
 */
public class roopkotha.app.WritePadMenu : Replicable {
	ArrayList<EventOwner> leftOptions;
	EventOwner rightOption;
	DocumentView lv;
	PlainDocument emptyDoc;
	public WritePadMenu() {
		leftOptions = ArrayList<EventOwner>();
		extring rightOptionText = extring.set_static_string("Quit");
		rightOption = new EventOwner(this, &rightOptionText);
		extring openFileText = extring.set_static_string("Open");
		EventOwner openFile = new EventOwner(this, &openFileText);
		leftOptions.set(0, openFile);
		guiinit();
	}
	void guiinit() {
		extring title = extring.set_static_string("Roopkotha");
		extring dc = extring.set_static_string("quit");
		lv = new DocumentView(&title, &dc);	
		emptyDoc = new PlainDocument();
		extring elem = extring.set_static_string("Write something here..");
		emptyDoc.addLine(&elem);
		lv.setDocument(emptyDoc, 0);
		lv.show();
	}
	protected void show(PlainDocument pd) {
		lv.setDocument(pd, 0);
		lv.showFull(&leftOptions, rightOption);
	}
}
/** @} */
