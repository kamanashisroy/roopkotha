using aroop;
using shotodol;
using roopkotha.velahandler;


public class roopkotha.velavanilla.VelaVanilla : roopkotha.velawidget.VelaVeil {
	public M100CommandSet velac;
	public CompoundResourceHandler cHandler;
	public VelaVanilla() {
		cHandler = new CompoundResourceHandler();
		base(cHandler);
		velac = new M100CommandSet();
		velac.register(new VelaVeilCommand(this));
	}

	void setupHandlers() {
		CommandResourceHandler hdlr = new CommandResourceHandler.givenCommandSet(velac);
		txt vxecute = new txt.from_static("velaxecute://");
		cHandler.handlers.set(vxecute, hdlr);
	}
}

