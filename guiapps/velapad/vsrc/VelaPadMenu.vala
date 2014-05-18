using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.vela;
using roopkotha.velatml;
using roopkotha.velagent;

/** \addtogroup velapp
 *  @{
 */
/**
 * You can only trust the numbers. 
 * [-Maturity- 10]
 */
internal class roopkotha.velapad.VelaPadMenu : VelaPadAgent {
	GUICoreImpl impl;
	PageView pg;
	VTMLDocument emptyDoc;
	public VelaPadMenu() {
		setupGUI();
	}
	void setupGUI() {
		impl = new GUICoreImpl();
		etxt velaTitle = etxt.from_static("Vela");
		etxt aboutVela = etxt.from_static("About");
		pg = new PageView.of_title(&velaTitle, &aboutVela);	
		emptyDoc = new VTMLDocument();
		/*etxt elem = etxt.from_static("Write something here..");
		emptyDoc.addLine(&elem);*/
		pg.setDocument(emptyDoc, 0);
		setupAgent(pg);
		pg.show();
		MainTurbine.gearup(impl);
	}
	protected void show(VTMLDocument doc) {
		pg.setDocument(doc, 0);
		pg.show();
	}
}
/** @} */
