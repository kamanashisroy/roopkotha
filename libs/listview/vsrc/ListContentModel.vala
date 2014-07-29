using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup listview
 *  @{
 */
public abstract class roopkotha.listview.ListContentModel : Replicable {
	public int selectedIndex;
	public ListContentModel() {
		selectedIndex = 0;
	}
	public abstract aroop.ArrayList<Replicable>*getItems();
	public abstract roopkotha.listview.ListViewItem getListItem(Replicable data);

 	public virtual int getCount() {
		return getItems().count_unsafe();
	}
	
	public virtual aroop.xtring? getHint() {
		return null;
	}
}
/** @} */
