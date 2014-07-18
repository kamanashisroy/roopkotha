using aroop;
using roopkotha.velagent;

public class roopkotha.velawidget.VelaVeil : roopkotha.velagent.Velagent {
	protected HashTable<xtring>veils;
	VelaResourceHandler handler;
	public VelaVeil(VelaResourceHandler handler) {
		base(handler);
		veils = HashTable<xtring>();
	}

	~VelaVeil() {
	}

	public void addVeil(xtring name, xtring menuMl) {
		veils.set(name, menuMl);
	}

	int changeVeil(extring*nm) {
		xtring?xMenu = veils.get(nm);
		if(xMenu == null) {
			return -1;
		}
		plugMenu(xMenu);
		return 0;
	}

	public override void onContentDisplay(VelaResource id, Replicable content) {
		if(changeVeil(&id.url) != 0) {
			extring default = extring.set_static_string("default");
			changeVeil(&default);
		}
	}
}

