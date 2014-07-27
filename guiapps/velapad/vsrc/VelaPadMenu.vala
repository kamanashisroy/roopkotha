using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.vela;
using roopkotha.veladivml;
using roopkotha.velagent;

/** \addtogroup velapp
 *  @{
 */
/**
 * You can only trust the numbers. 
 * [-Maturity- 10]
 */
internal class roopkotha.velapad.VelaPadMenu : Replicable {
	PageView pg;
	VelaDivDocument emptyDoc;
	velavanilla.VelaVanilla vagent;
	public VelaPadMenu() {
		setupGUI();
	}
	void setupGUI() {
		extring velaTitle = extring.set_static_string("Vela");
		extring aboutVela = extring.set_static_string("About");
		pg = new PageView.of_title(&velaTitle, &aboutVela);	
		emptyDoc = new VelaDivDocument();
		/*extring elem = extring.set_static_string("Write something here..");
		emptyDoc.addLine(&elem);*/
		//pg.setDocument(emptyDoc, 0);
		vagent = velavanilla.VelaVanillaModule.vanilla;
		vagent.plugPage(pg);
		extring baseUrl = extring.set_static_string("");
		extring url = extring.set_static_string("file://empty");
		VelaResource res = new VelaResource(&baseUrl, &url, emptyDoc);
		vagent.onContentReady(res, emptyDoc);
	}
	protected void show(VelaDivDocument doc) {
		pg.setDocument(doc, 0);
		pg.show();
	}
}
/** @} */
