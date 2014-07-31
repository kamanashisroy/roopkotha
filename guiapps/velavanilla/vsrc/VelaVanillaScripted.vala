using aroop;
using roopkotha.velawidget;


public class roopkotha.velavanilla.VelaVanillaScripted : roopkotha.velavanilla.VelaVanilla {
	shotodol.M100Script? script;
	shotodol.StandardOutputStream stdo;
	public VelaVanillaScripted() {
		base();
		script = null;
		extring rls = extring.set_static_string("velapp/velavanilla.mk");
		loadRules(&rls);
		stdo = new shotodol.StandardOutputStream();
		loadall();
	}
	public void loadRules(extring*fn) {
		try {
			shotodol.FileInputStream f = new shotodol.FileInputStream.from_file(fn);
			shotodol.LineInputStream lis = new shotodol.LineInputStream(f);
			script = new shotodol.M100Script();
			script.startParsing();
			extring buf = extring.stack(1024);
			while(true) {
				try {
					buf.trim_to_length(0);
					if(lis.read(&buf) == 0) {
						break;
					}
					script.parseLine(&buf);
				} catch(IOStreamError.InputStreamError e) {
					break;
				}
			}
			lis.close();
			f.close();
			script.endParsing();
		} catch (IOStreamError.FileInputStreamError e) {
		}
	}
	public void velaExecRule(extring*tgt) {
		extring dlg = extring.stack(128);
		if(script == null) {
			dlg.printf("target:%s is undefined", tgt.to_string());
			shotodol.Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
			return;
		}
		dlg.printf("target:%s\n", tgt.to_string());
		shotodol.Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
		script.target(tgt);
		while(true) {
			xtring? cmd = script.step();
			if(cmd == null) {
				break;
			}
			//dlg.printf("command:%s\n", cmd.to_string());
			//shotodol.Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
			// execute command
			velac.act_on(cmd, stdo, script);
		}
	}

	public int loadall() {
		extring dlg = extring.set_static_string("all");
		velaExecRule(&dlg);
		return 0;
	}

	public int setVariableInt(extring*varName,int intVal) {
               	shotodol.M100Variable val = new shotodol.M100Variable();
               	val.setInt(intVal);
               	xtring nm = new xtring.copy_on_demand(varName);
              	velac.vars.set(nm, val);
		return 0;
	}

	public int setVariable(extring*varName,extring*varVal) {
               	shotodol.M100Variable val = new shotodol.M100Variable();
               	val.set(varVal);
               	xtring nm = new xtring.copy_on_demand(varName);
              	velac.vars.set(nm, val);
		return 0;
	}
}

