using aroop;
using shotodol;
using roopkotha;

public class roopkotha.GUICoreImpl : roopkotha.GUICore {
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

	public override int start(Propeller?plr) { 
		print("GUICore stepping started..\n");
		return 0;
	}
}
