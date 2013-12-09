using aroop;
using shotodol;
using roopkotha;

public class roopkotha.GraphicsImpl : roopkotha.Graphics {
	internal GraphicsPlatformImpl plat;
	public GraphicsImpl() {
		plat = GraphicsPlatformImpl();
	}
	~GraphicsImpl() {
		plat.destroy();
	}
	public override void drawImage(onubodh.RawImage img, int x, int y, int anc) {
		plat.drawImage(img, x, y, anc);
	}
	public override void drawLine(int x1, int y1, int x2, int y2) {
		plat.drawLine(x1, y1, x2, y2);
	}
	public override void drawRect(int x, int y, int width, int height) {
		plat.drawRect(x, y, width, height);
	}
	public override void drawRoundRect(int x, int y, int width, int height, int arcWidth, int arcHeight) {
		plat.drawRoundRect(x, y, width, height, arcWidth, arcHeight);
	}
	public override void drawString(aroop.txt str, int x, int y, int width, int height, int anc) {
		plat.drawString(str, x, y, width, height, anc);
	}
	public override void fillRect(int x, int y, int width, int height) {
		plat.fillRect(x, y, width, height);
	}
	public override void fillRoundRect(int x, int y, int width, int height, int arcWidth, int arcHeight) {
		plat.fillRoundRect(x, y, width, height, arcWidth, arcHeight);
	}
	public override void fillTriangle(int x1, int y1, int x2, int y2, int x3, int y3) {
		plat.fillTriangle(x1, y1, x2, y2, x3, y3);
	}
	public override int getColor() {
		return plat.getColor();
	}
	public override void setColor(int rgb) {
		plat.setColor(rgb);
	}
	public override void setFont(roopkotha.Font font) {
		plat.setFont((font as FontImpl).plat);
	}
	public override void start() {
		plat.start();
	}
}

