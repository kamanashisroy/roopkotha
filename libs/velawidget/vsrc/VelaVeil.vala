using aroop;
using roopkotha.velagent;

public class roopkotha.velawidget.VelaVeil : roopkotha.velagent.Velagent {
	protected HashTable<txt>veils;
	VelaResourceHandler handler;
	public VelaVeil(VelaResourceHandler handler) {
		base(handler);
		veils = HashTable<txt>();
	}

	~VelaVeil() {
	}

	public void addVeil(txt name, txt menuMl) {
		print("Adding %s menu %s\n", name.to_string(), menuMl.to_string());
		veils.set(name, menuMl);
	}

	int changeVeil(etxt*nm) {
		txt?xMenu = veils.get(nm);
		if(xMenu == null) {
			return -1;
		}
		plugMenu(xMenu);
		return 0;
	}

	public override void onContentDisplay(VelaResource id, Replicable content) {
		if(changeVeil(&id.url) != 0) {
			etxt default = etxt.from_static("default");
			changeVeil(&default);
		}
	}
}

