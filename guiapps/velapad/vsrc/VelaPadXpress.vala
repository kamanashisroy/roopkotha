using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.doc;
using roopkotha.vela;
using roopkotha.velagent;
using roopkotha.velatml;


public class roopkotha.velapad.VelaPadXpress : roopkotha.velagent.Velagent {
	protected HashTable<txt>panelTypes;
	public static M100CommandSet xCmds;
	public VelaPadXpress() {
		xCmds = new M100CommandSet();
		CommandResourceLoader loader = new CommandResourceLoader.givenCommandSet(xCmds);
		base(loader);
		panelTypes = HashTable<txt>();
		fileDialog();aboutDialog();mainDialog();
	}

	~VelaPadXpress() {
		xCmds = null;
	}

	int fileDialog() {
		txt menu = new txt.from_static("<x href=\"ls\" label=Open></x><x href=close label=Close>a</x>");
		txt key = new txt.from_static("velaxecute://ls");
		panelTypes.set(key, menu);
		return 0;
	}

	int aboutDialog() {
		txt menu = new txt.from_static("<x href=close label=Close>a</x>");
		txt key = new txt.from_static("velaxecute://about");
		panelTypes.set(key, menu);
		return 0;
	}

	int mainDialog() {
		txt menu = new txt.from_static("<x href=goback label=Back></x><x href=quit label=Quit></x><x href=aboutme label=About></x><x href=ls label=Open></x><x href=close label=Close>a</x>");
		txt key = new txt.from_static("main");
		panelTypes.set(key, menu);
		return 0;
	}

	public override void onContentDisplay(VelaResource id, Replicable content) {
		etxt mainKey = etxt.from_static("main");
		txt?mainMenu = panelTypes.get(&mainKey);
		txt?xMenu = panelTypes.get(&id.url);
		print("Searching menu for %s[%d]\n", id.url.to_string(), id.url.length());
		if(xMenu != null) {
			plugMenu(xMenu);
		} else if(mainMenu != null) {
			plugMenu(mainMenu);
		}
	}
}

