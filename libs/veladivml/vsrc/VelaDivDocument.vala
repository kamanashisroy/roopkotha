using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.doc;
using roopkotha.vela;

/**
 * \ingroup vela
 * \defgroup veladivml HTML like content support to display application controls.
 */

/** \addtogroup veladivml
 *  @{
 */
/**
 * You can only trust the numbers. 
 * [-Maturity- 10]
 */
/**
 * This is the base class for all the documents we render in roopkotha
 */
public class roopkotha.veladivml.VelaDivDocument : roopkotha.doc.RoopDocument {
	int counter;
	InputStream? instrm;
	extring rawData;
	enum config {
		MAX_DIV_SIZE = 64,
	}
	public VelaDivDocument() {
		counter = 0;
		instrm = null;
		base();
		rawData = extring();
	}

	~VelaDivDocument() {
		rawData.destroy();
	}
	
	public virtual void spellChunk(extring*asciiData) {
		rawData.concat(asciiData);
	}

	public void setInputStream(InputStream istrm) {
		instrm = istrm;
	}

	public void tryReading() {
		rawData.destroy();
		// TODO get the file size and allocate memory accordingly
		rawData.buffer(config.MAX_DIV_SIZE<<2);
		do {
			extring data = extring.stack(config.MAX_DIV_SIZE);
			core.assert(instrm != null);
			try {
				int bytesRead = instrm.read(&data);
				if(bytesRead == 0) break;
				spellChunk(&data);
			} catch(IOStreamError.InputStreamError e) {
				break;
			}
		} while(true);
		percept(&rawData);
	}

	onubodh.XMLParser?parser;
	void traverseContents(onubodh.XMLIterator*xit) {
		if(xit.nextIsText) {
			extring content = extring.stack(config.MAX_DIV_SIZE);
			xit.m.getSourceReferenceAs(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.content.length(), &content);
			PlainContent pc = new PlainContent(&content);
			contents.set(counter++, pc);
			return;
		}
		extring key = extring.stack(config.MAX_DIV_SIZE);
		extring href = extring();
		href.buffer(config.MAX_DIV_SIZE);
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
			}
		}
		while(href.char_at(0) == '"') {href.shift(1);}
		while(href.char_at(href.length()-1) == '"') {href.trim_to_length(href.length()-1);}
		href.zero_terminate();
		onubodh.XMLIterator pl = onubodh.XMLIterator(xit.m);
		if(parser.peelCapsule(&pl, xit) != 0) {
			return;
		}
		xit.inner = null;
		extring content = extring.stack(config.MAX_DIV_SIZE);
		pl.m.getSourceReferenceAs(pl.basePos + pl.shift, pl.basePos + pl.shift + pl.kernel.length(), &content);
		content.zero_terminate();
		//print("[%d,%d,%d]%s\n", pl.basePos, pl.shift, pl.kernel.length(), content.to_string());
		//xit.m.getSourceReferenceAs(xit.basePos + xit.shift, xit.basePos + xit.shift + xit.kernel.length(), &content);
		//print("[%d,%d,%d]%s\n", xit.basePos, xit.shift, xit.content.length(), content.to_string());
		//print("[%s]\n", content.to_string());
		if(xit.nextTag.equals_static_string("LI")) {
			VelaListItemContent vlc = new VelaListItemContent(&content, &href, false);
			contents.set(counter++, vlc);
		} else {
			VelaDivContent vrc = new VelaDivContent(&content, &href, false);
			contents.set(counter++, vrc);
		}
	}

	public int percept(extring*rawContent = null) {
		parser = new onubodh.XMLParser();
		onubodh.WordMap map = onubodh.WordMap();
		// parse the xml and show the menu
		if(rawContent == null) {
			rawContent = &rawData;
		}
		map.kernel.buffer(rawContent.length());
		map.source = extring.copy_on_demand(rawContent);
		map.map.buffer(rawContent.length());
		parser.transform(&map);

		// traverse
		parser.traversePreorder(&map, 1, traverseContents);
		map.destroy();
		rawData.destroy(); // XXX we are releasing the content memory ..
		parser = null;
		return 0;
	}
}
/** @} */
