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
internal class roopkotha.app.VelaPadMenu : VelaPadAgent {
	GUICoreImpl impl;
	PageView pg;
	PageAppDocument emptyDoc;
	public VelaPadMenu() {
		setupGUI();
	}
	void setupGUI() {
		impl = new GUICoreImpl();
		etxt velaTitle = etxt.from_static("Vela");
		etxt aboutVela = etxt.from_static("About");
		pg = new PageView.of_title(&velaTitle, &aboutVela);	
		emptyDoc = new PageAppDocument();
		/*etxt elem = etxt.from_static("Write something here..");
		emptyDoc.addLine(&elem);*/
		pg.setDocument(emptyDoc, 0);
		setupAgent(pg);
		pg.show();
		MainTurbine.gearup(impl);
	}
	protected void show(PageAppDocument pd) {
		pg.setDocument(pd, 0);
		pg.show();
	}
}
/** @} */
