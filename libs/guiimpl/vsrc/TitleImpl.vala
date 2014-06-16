using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup guiimpl
 *  @{
 */
public class roopkotha.gui.TitleImpl : roopkotha.gui.Pane {
	txt title;
	int width;
	int height;
	int panelTop;
	public int PADDING;
	GraphicsPixelMap?gfx;
	protected Font?TITLE_FONT;
	unowned Window parent; // avoid circular reference
	public TitleImpl(Window gParent, etxt*aTitle, int gPadding) {
		title = new txt.memcopy_etxt(aTitle);
		TITLE_FONT = new FontImpl();
		gfx = null;
		width = 10;
		height = 10;
		PADDING = gPadding;
		dirty = true;
		parent = gParent;
	}

	public int setTitle(aroop.txt gTitle) {
		title = gTitle;
		return 0;
	}

	public int setSize(int gWidth, int gHeight) {
		width = gWidth;
		height = gHeight;
		panelTop = TITLE_FONT.getHeight() + PADDING*2;
		return 0;
	}

	public override void paint(roopkotha.gui.Graphics g) {
		g.start(parent, 10);
		/* Cleanup Background */
		// #expand g.setColor(%net.ayaslive.miniim.ui.core.window.titleBg%);
		g.setColor(0x006699);
		g.fillRect(0, 0, this.width, this.panelTop);
		// #ifdef net.ayaslive.miniim.ui.core.window.titleShadow
		// draw shadow
		// #expand g.setColor(%net.ayaslive.miniim.ui.core.window.titleShadow%);
		g.setColor(0x009900);
		g.drawLine(0, this.panelTop, this.width, this.panelTop);
		// #endif
		/* Write the title */
		// #expand g.setColor(%net.ayaslive.miniim.ui.core.window.titleFg%);
		g.setColor(0xFFFFFF);
		g.setFont(TITLE_FONT);
		g.drawString(title, 0, 2
				, width
				//, height
				, panelTop
				//, 1);
				, roopkotha.gui.Graphics.anchor.TOP |roopkotha.gui.Graphics.anchor.HCENTER);
		//core.assert("Reached" == null);
		dirty = false;
	}

	public override roopkotha.gui.Graphics getGraphics() {
		if(gfx != null)
			return gfx;
		GUITask task = GUICoreImpl.gcore.taskFactory.alloc_full(128);
		task.build(128);
		gfx = new GraphicsPixelMap.fromTask(task);
		return gfx;
	}
}

/** @} */
