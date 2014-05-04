using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.vela;
using roopkotha.velagent;

/** \addtogroup velapp
 *  @{
 */
/**
 * You can only trust the numbers. 
 * [-Maturity- 10]
 */
internal class roopkotha.app.VelaPadMenu : Replicable {
#if false
	ArrayList<EventOwner> leftOptions;
	EventOwner rightOption;
#endif
	GUICoreImpl impl;
	PageView pg;
	PageAppDocument emptyDoc;
	public VelaPadMenu() {
#if false
		leftOptions = ArrayList<EventOwner>();
		etxt rightOptionText = etxt.from_static("Quit");
		rightOption = new EventOwner(this, &rightOptionText);
		etxt openFileText = etxt.from_static("Open");
		EventOwner openFile = new EventOwner(this, &openFileText);
		etxt moreText = etxt.from_static("More");
		EventOwner more = new EventOwner(this, &moreText);
		leftOptions.set(0, openFile);
		leftOptions.set(1, more);
#endif
		guiinit();
	}
	void guiinit() {
		impl = new GUICoreImpl();
		etxt velaTitle = etxt.from_static("Vela");
		etxt aboutVela = etxt.from_static("About");
		pg = new PageView.of_title(&velaTitle, &aboutVela);	
		emptyDoc = new PageAppDocument();
		/*etxt elem = etxt.from_static("Write something here..");
		emptyDoc.addLine(&elem);*/
		pg.setDocument(emptyDoc, 0);
		new Velagent(pg, new CompoundResourceLoader());
		etxt menuML = etxt.from_static("<menu><x href=\"opennew\">Open</x><x href=\"close\">Close</x></menu>");
		pg.setMenu(&menuML);
		pg.show();
		MainTurbine.gearup(impl);
	}
	protected void show(PageAppDocument pd) {
		pg.setDocument(pd, 0);
		//pg.showFull(&leftOptions, rightOption);
		pg.show();
	}
}
/** @} */
