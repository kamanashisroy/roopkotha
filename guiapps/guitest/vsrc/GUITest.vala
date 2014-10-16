using aroop;
using shotodol;
using roopkotha;
using roopkotha.gui;

/** \addtogroup guitest
 *  @{
 */
internal class roopkotha.app.GUITest : UnitTest {
  public GUITest() {
	extring tname = extring.set_static_string("gui");
	base(&tname);
  }
  public override int test() throws UnitTestError {
	print("GUITest:Sending an echo message\n");
	Bag echoTask = GUICoreModule.bagBuilder.createBag(32);
	Bundler bndlr = Bundler();
	bndlr.buildFromCarton(&echoTask.msg, 32);
	bndlr.writeInt(GUICore.entries.MISC_TASK, GUICore.MiscTasks.ECHO_MESSAGE);
	extring msg = extring.set_static_string("Working\n");
	bndlr.writeEXtring(GUICore.entries.ARG, &msg);
	echoTask.finalize(&bndlr);
	extring task = extring();
	echoTask.getContentAs(&task);
	GUICoreModule.gcore.pushTask(&task);
	return 0;
  }
}
/** @} */
