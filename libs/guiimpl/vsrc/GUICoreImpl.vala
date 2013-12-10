using aroop;
using shotodol;
using roopkotha;

public class roopkotha.GUICoreImpl : roopkotha.GUICore {
	GUICorePlatformImpl plat;
	public GUICoreImpl() {
		base();
		plat = GUICorePlatformImpl.create();
	}
	
	~GUICoreImpl() {
	}
	
	public override int step() {
		plat.step();
		base.step();
		plat.step();
		return 0;
    }
    
#if false
    public override int cmain(int*argc, string argv[]) {
		plat.cmain(argc, argv);
		return 0;
	}
#endif

	public override int start(Propeller?plr) { 
		print("GUICore stepping started..\n");
		return 0;
	}
}
