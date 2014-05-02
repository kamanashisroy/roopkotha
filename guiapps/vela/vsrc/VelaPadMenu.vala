using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.vela;

/** \addtogroup velapp
 *  @{
 */
/**
 * You can only trust the numbers. 
 * [-Maturity- 10]
 */
internal class roopkotha.app.VelaPadMenu : Replicable {
	ArrayList<EventOwner> leftOptions;
	EventOwner rightOption;
	GUICoreImpl impl;
	PageView pg;
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
		etxt velaTitle = etxt.from_static("Vela");
		etxt aboutVela = etxt.from_static("About");
		pg = new PageView.of_title(&velaTitle, &aboutVela);	
		emptyDoc = new PageAppDocument();
		/*etxt elem = etxt.from_static("Write something here..");
		emptyDoc.addLine(&elem);*/
		pg.setDocument(emptyDoc, 0);
		new WebControler(pg, new CompoundResourceLoader());
		pg.show();
		MainTurbine.gearup(impl);
	}
	protected void show(PageAppDocument pd) {
		pg.setDocument(pd, 0);
		pg.showFull(&leftOptions, rightOption);
	}
}
/** @} */
