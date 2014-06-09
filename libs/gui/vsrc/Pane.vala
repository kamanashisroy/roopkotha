using aroop;
using shotodol;
using roopkotha.gui;

/**
 * \ingroup roopkotha
 * @defgroup gui GUI
 */

/** \addtogroup gui
 *  @{
 */
public abstract class roopkotha.gui.Pane : Replicable {
	public abstract void paint(roopkotha.gui.Graphics g);
	public abstract roopkotha.gui.Graphics getGraphics();
}

/** @} */
