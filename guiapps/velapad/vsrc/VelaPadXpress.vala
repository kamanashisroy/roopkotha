using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.doc;
using roopkotha.vela;
using roopkotha.velagent;
using roopkotha.velatml;


public class roopkotha.velapad.VelaPadXpress : roopkotha.velawidget.VelaVeil {
	protected HashTable<txt>panelTypes;
	public static M100CommandSet xCmds;
	public VelaPadXpress() {
		xCmds = new M100CommandSet();
		CommandResourceHandler handler = new CommandResourceHandler.givenCommandSet(xCmds);
		base(handler);
		panelTypes = HashTable<txt>();
		fileDialog();aboutDialog();mainDialog();
	}

	~VelaPadXpress() {
		xCmds = null;
	}

	int fileDialog() {
		txt menu = new txt.from_static("<x href=\"ls\" label=Open></x><x href=close label=Close>a</x>");
		txt key = new txt.from_static("velaxecute://ls");
		addVeil(key, menu);
		return 0;
	}

	int aboutDialog() {
		txt menu = new txt.from_static("<x href=close label=Close>a</x>");
		txt key = new txt.from_static("velaxecute://about");
		addVeil(key, menu);
		return 0;
	}

	int mainDialog() {
		txt menu = new txt.from_static("<x href=goback label=Back></x><x href=quit label=Quit></x><x href=aboutme label=About></x><x href=ls label=Open></x><x href=close label=Close>a</x>");
		txt key = new txt.from_static("default");
		addVeil(key, menu);
		return 0;
	}

}

