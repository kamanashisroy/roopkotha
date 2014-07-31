using aroop;
using roopkotha.velagent;

public class roopkotha.velawidget.VelaVeil : roopkotha.velagent.VelaRebound {
	protected HashTable<xtring,xtring>veils;
	public VelaVeil(VelaResourceHandler handler) {
		veils = HashTable<xtring,xtring>(xtring.hCb,xtring.eCb);
		base(handler);
	}

	~VelaVeil() {
		veils.destroy();
	}

	public void addVeil(xtring name, xtring menuMl) {
		veils.set(name, menuMl);
	}

	int changeVeil(extring*nm) {
		xtring?xMenu = veils.getProperty(nm);
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

