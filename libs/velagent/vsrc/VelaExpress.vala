using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.doc;
using roopkotha.vela;
using roopkotha.velatml;


public class roopkotha.velagent.VelaExpress : roopkotha.velagent.Velagent {
	HashTable<txt>panelTypes;
	M100CommandSet cmds;
	public VelaExpress() {
		cmds = new M100CommandSet();
		CommandResourceLoader loader = new CommandResourceLoader.givenCommandSet(cmds);
		base(loader);
		panelTypes = HashTable<txt>();
		txt docViewMenu = new txt.from_static("<x href=goback label=Back></x><x href=quit label=Quit></x><x href=aboutme label=About></x><x href=ls label=Open></x><x href=close label=Close>a</x>");
		txt docViewKey = new txt.from_static("default");
		panelTypes.set(docViewKey, docViewMenu);
	}
	public override void plugPage(PageView view) {
		base.plugPage(view);
		etxt default = etxt.from_static("default");
		txt?docViewMenu = panelTypes.get(&default);
		if(docViewMenu != null) {
			plugMenu(docViewMenu);
		}
	}
}

