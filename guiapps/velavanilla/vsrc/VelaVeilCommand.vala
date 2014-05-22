using aroop;
using shotodol;
using roopkotha.velawidget;
using roopkotha.velavanilla;

/** \addtogroup velavanilla
 *  @{
 */
internal class roopkotha.velavanilla.VelaVeilCommand : M100Command {
	etxt prfx;
	VelaVeil veil;
	public VelaVeilCommand(VelaVeil gvl) {
		base();
		veil = gvl;
	}
	
	public override etxt*get_prefix() {
		prfx = etxt.from_static("menu");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		etxt inp = etxt.stack_from_etxt(cmdstr);
		etxt token = etxt.EMPTY();
		LineAlign.next_token(&inp, &token); // second token
		etxt name = etxt.EMPTY();
		LineAlign.next_token(&inp, &name); // second token
		if(name.is_empty() || inp.is_empty()) {
			bye(pad, false);
			return 0;
		}
		txt nm = new txt.memcopy_etxt(&name);
		txt menu = new txt.memcopy_etxt(&inp);
		veil.addVeil(nm, menu);
		bye(pad, true);
		return 0;
	}
}
/* @} */
