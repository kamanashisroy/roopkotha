using aroop;
using shotodol;
using roopkotha.gui;
using roopkotha.gui.listview;

/** \addtogroup listview
 *  @{
 */
public abstract class roopkotha.gui.listview.ListContentModel : Replicable {
	public int selectedIndex;
	public ListContentModel() {
		selectedIndex = 0;
	}
	public abstract aroop.ArrayList<Replicable>*getItems();
	public abstract ListViewItem getListItem(Replicable data);

 	public virtual int getCount() {
		return getItems().count_unsafe();
	}
	
	public virtual void getHintAs(extring*outHint) {
	}
}
/** @} */
