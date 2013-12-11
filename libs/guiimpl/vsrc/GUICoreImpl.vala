using aroop;
using shotodol;
using roopkotha;

public class roopkotha.GUICoreImpl : roopkotha.GUICore {
	GUICorePlatformImpl plat;
	public GUICoreImpl() {
		plat = GUICorePlatformImpl.create();
		base(new GraphicsImpl());
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
