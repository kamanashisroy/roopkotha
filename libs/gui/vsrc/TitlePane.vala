using aroop;
using shotodol;
using roopkotha.gui;

/** \addtogroup gui
 *  @{
 */
public class roopkotha.gui.TitlePane : roopkotha.gui.Pane {
	xtring title;
	int width;
	int height;
	int panelTop;
	public int PADDING;
	GraphicsTask?gfx;
	protected Font?TITLE_FONT;
	public TitlePane(extring*aTitle) {
		title = new xtring.copy_on_demand(aTitle);
		TITLE_FONT = new BasicFont();
		gfx = null;
		width = 10;
		height = 10;
		PADDING = 1;
		dirty = true;
	}

	public int setTitle(aroop.xtring gTitle) {
		title = gTitle;
		return 0;
	}

	public override void onResize(int l, int t, int gWidth, int gHeight, int gPadding) {
		width = gWidth;
		height = gHeight;
		PADDING = gPadding;
		panelTop = TITLE_FONT.getHeight() + PADDING*2;
		dirty = true;
	}

	public int getVerticalSpanBottom() {
		return panelTop;
	}

	public override void paint(roopkotha.gui.Graphics g) {
		/* Cleanup Background */
		// #expand g.setColor(%net.ayaslive.miniim.ui.core.window.titleBg%);
		g.setColor(0x006699);
		g.fillRect(0, 0, width, panelTop);
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
		if(gfx != null && !gfx.isUsed())
			return gfx;
		Bag task = GUICoreModule.bagBuilder.createBag(128);
		gfx = new GraphicsTask.fromTask(task);
		return gfx;
	}
}

/** @} */
