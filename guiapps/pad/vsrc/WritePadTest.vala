using aroop;
using shotodol;
using roopkotha;

/** \addtogroup padapp
 *  @{
 */
internal class roopkotha.app.WritePadTest : UnitTest {
  public WritePadTest() {
	extring tname = extring.set_static_string("WritePad Test");
	base(&tname);
  }
  public override int test() throws UnitTestError {
	print("WritePadTest:~~~~TODO fill me\n");
	return 0;
  }
#if false
	//Turbine gtb;
	void test_ui() {
		Watchdog.logString("test gui started .\n");
		//impl = new GUICoreImpl();
		//gtb = new Turbine();
		//gtb.gearup(impl);
		//xultb_guicore_system_init(&argc, argv);

		extring title = extring.set_static_string("Test");
		extring dc = extring.set_static_string("quit");

		SimpleListView slv = new SimpleListView(&title, &dc);	

		Watchdog.logString("WritePadCommand:test_ui:adding list item\n");
		extring elem = extring.set_static_string("good");
		ListViewItemComplex item = new ListViewItemComplex.createLabel(&elem, null);
		slv.setListViewItem(0, item);


		MainTurbine.gearup(impl);
		slv.show();
		Watchdog.logString("WritePadCommand:test_ui:list show\n");
		//gtb.startup();
	}
	void test_doc() {
		PlainDocument testDoc = new PlainDocument();
		extring elem = extring.set_static_string("good");
		testDoc.addLine(&elem);
		show(testDoc);
	}
#endif
}
/** @} */
