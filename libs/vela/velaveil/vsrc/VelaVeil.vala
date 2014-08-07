using aroop;
using roopkotha.vela;
using roopkotha.velagent;

/**
 * \ingroup velawidget
 * \defgroup velaveil Veil is the menu system for vela.
 */

/** \addtogroup velaveil
 *  @{
 */
public class roopkotha.velawidget.VelaVeil : Replicable {
	HashTable<xtring,xtring>veils;
	PageWindow?page;
	VelaResourceHandler?handler;
	public VelaVeil() {
		veils = HashTable<xtring,xtring>(xtring.hCb,xtring.eCb);
		handler = null;
		page = null;
	}

	~VelaVeil() {
		veils.destroy();
	}

	public void plugPage(PageWindow?pg) {
		if(pg == null) {
			veils.markAll(0x02);
			veils.pruneMarked(0x02);
		}
		page = pg;
	}

	public void plugHandler(VelaResourceHandler?givenHandler) {
		handler = givenHandler;
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

	public void onContentDisplay(extring*url) {
		if(changeVeil(url) != 0) {
			extring default = extring.set_static_string("default");
			changeVeil(&default);
		}
	}

	void traverseMenu(onubodh.XMLIterator*xit) {
		if(xit.nextIsText) {
			return;
		}
		extring key = extring.stack(128);
		extring href = extring();
		href.buffer(128);
		extring label = extring();
		label.buffer(32);
		extring attrKey = extring();
		extring attrVal = extring();
		while(xit.nextAttr(&attrKey, &attrVal)) {
			// trim ..
			key.trim_to_length(0);
			key.concat(&attrKey);
			key.zero_terminate();
			while(key.char_at(0) == ' ') {key.shift(1);}
			if(key.equals_string("href")) {
				href.concat(&attrVal);
			} else if(key.equals_string("label")) {
				label.concat(&attrVal);
			}
		}
		while(href.char_at(0) == '"') {href.shift(1);}
		while(href.char_at(href.length()-1) == '"') {href.trim_to_length(href.length()-1);}
		href.zero_terminate();
		if(href.is_empty()) {
			return;
		}
		while(label.char_at(0) == ' ') {label.shift(1);}
		while(label.char_at(0) == '"') {label.shift(1);}
		while(label.char_at(label.length()-1) == '"') {label.trim_to_length(label.length()-1);}
		label.zero_terminate();
		if(label.is_empty()) {
			return;
		}
		PageEventOwner x = new PageEventOwner(&href, &label, handler);
		page.addMenu(x);
		return;
	}
	public int plugMenu(extring*menuML) {
		onubodh.XMLParser parser = new onubodh.XMLParser();
		onubodh.WordMap map = onubodh.WordMap();
		// parse the xml and show the menu
		map.kernel.buffer(menuML.length());
		map.source = extring.copy_on_demand(menuML);
		map.map.buffer(menuML.length());
		parser.transform(&map);

		page.resetMenu();

		// traverse
		parser.traversePreorder(&map, 100, traverseMenu);
		page.finalizeMenu();
		map.destroy();
		return 0;
	}
}

