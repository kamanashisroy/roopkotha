using aroop;
using shotodol;
using roopkotha.velawidget;
using roopkotha.velavanilla;

/** \addtogroup velavanilla
 *  @{
 */
internal class roopkotha.velavanilla.VelaVeilCommand : M100Command {
	VelaVeil veil;
	public VelaVeilCommand(VelaVeil gvl) {
		extring prefix = extring.set_static_string("menu");
		base(&prefix);
		veil = gvl;
	}
	
	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		extring inp = extring.stack_copy_deep(cmdstr);
		extring token = extring();
		LineAlign.next_token(&inp, &token); // second token
		extring name = extring();
		LineAlign.next_token(&inp, &name); // second token
		if(name.is_empty() || inp.is_empty()) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring nm = new xtring.copy_on_demand(&name);
		xtring menu = new xtring.copy_on_demand(&inp);
		veil.addVeil(nm, menu);
		return 0;
	}
}
/* @} */
