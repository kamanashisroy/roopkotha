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
internal class roopkotha.velapad.VelaPadMenu : Replicable {
	GUICoreImpl impl;
	PageView pg;
	VTMLDocument emptyDoc;
	velavanilla.VelaVanilla vagent;
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
		//pg.setDocument(emptyDoc, 0);
		vagent = velavanilla.VelaVanillaModule.vanilla;
		vagent.plugPage(pg);
		etxt baseUrl = etxt.from_static("");
		etxt url = etxt.from_static("file://empty");
		VelaResource res = new VelaResource(&baseUrl, &url, emptyDoc);
		vagent.onContentReady(res, emptyDoc);
		MainTurbine.gearup(impl);
	}
	protected void show(VTMLDocument doc) {
		pg.setDocument(doc, 0);
		pg.show();
	}
}
/** @} */
