using aroop;
using shotodol;
using roopkotha;

/** \addtogroup padapp
 *  @{
 */
internal class roopkotha.app.WritePadTest : UnitTest {
  etxt tname;
  public WritePadTest() {
    tname = etxt.from_static("WritePad Test");
  }
  public override aroop_hash getHash() {
    return tname.getStringHash();
  }
  public override void getName(etxt*name) {
    name.dup_etxt(&tname);
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

		etxt title = etxt.from_static("Test");
		etxt dc = etxt.from_static("quit");

		SimpleListView slv = new SimpleListView(&title, &dc);	

		Watchdog.logString("WritePadCommand:test_ui:adding list item\n");
		etxt elem = etxt.from_static("good");
		ListViewItemComplex item = new ListViewItemComplex.createLabel(&elem, null);
		slv.setListViewItem(0, item);


		MainTurbine.gearup(impl);
		slv.show();
		Watchdog.logString("WritePadCommand:test_ui:list show\n");
		//gtb.startup();
	}
	void test_doc() {
		PlainDocument testDoc = new PlainDocument();
		etxt elem = etxt.from_static("good");
		testDoc.addLine(&elem);
		show(testDoc);
	}
#endif
}
/** @} */
