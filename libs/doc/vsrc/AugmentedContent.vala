using aroop;
using shotodol;
using roopkotha;

/**
 * This is the base class for all the documents we render in roopkotha
 */
public abstract class roopkotha.AugmentedContent : Replicable {
	public enum ContentType {
		UNKNOWN_CONTENT,
		PLAIN_CONTENT,
		LABEL_CONTENT,
		TEXT_INPUT_CONTENT,
		SELECTION_CONTENT,
		RADIO_CONTENT,
		CHECKBOX_CONTENT,
		MARKUP_CONTENT,
	}
	public ContentType cType {public get;protected set;}
	public AugmentedContent() {
		cType = ContentType.UNKNOWN_CONTENT;
	}
	public virtual int getLabel(etxt*data) {
		return 0;
	}
	public virtual int getText(etxt*data) {
		return 0;
	}
	public virtual onubodh.RawImage?getImage() {
		// TODO fill me
		//Image img = null;
		//String src = elem.getAttributeValue("src");
		//if(src != null) {
			//img = ml.getImage(src);
		//}
		return null;
	}
	public virtual bool hasAction() {
		// elem.getAttributeValue("href") != null
		return false;
	}
	public virtual bool isPassword() {
		// TODO fill me
		return false;
	}
	public virtual bool canBeWrapped() {
		// TODO fill me
		return false;
	}
	public virtual bool isChecked() {
		// TODO fill me
		//isPositiveAttribute(elem, "c")
		return false;
	}
	public virtual bool isDefaultSelected() {
		// TODO fill me
		//isPositiveAttribute(elem, "s")
		return false;
	}
}

