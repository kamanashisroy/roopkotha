using aroop;
using shotodol;
using roopkotha.platform;
using roopkotha.gui;

public class roopkotha.gui.GUICoreImpl : roopkotha.gui.GUICore {
	GUICorePlatformImpl plat;
	public GUICoreImpl() {
		print("Creating new platform application\n");
		plat = GUICorePlatformImpl.create();
		base(new GraphicsImpl());
		step();
	}
	
	~GUICoreImpl() {
	}
	
	public override int step() {
		plat.step();
		base.step();
		plat.step();
		return 0;
  }

	public override int start(shotodol.Spindle?plr) { 
		print("GUICore stepping started..\n");
		return 0;
	}
}
