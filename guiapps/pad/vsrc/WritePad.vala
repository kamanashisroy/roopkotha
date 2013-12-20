using aroop;
using shotodol;
using roopkotha;

public class roopkotha.WritePad : WritePadMenu {
	public WritePad() {
		base();
	}
	public int loadFile(etxt*fn) {
		Watchdog.logString("WritePadCommand:Open file ...\n");
		try {
			FileInputStream fistm = new FileInputStream.from_file(fn);
			Watchdog.logString("WritePadCommand:Open file: Opened file for reading ...\n");

			PlainDocument pd = new PlainDocument();
			Watchdog.logString("WritePadCommand:Open file: Reading ...\n");

			pd.setInputStream(fistm);
			pd.tryReading();
			fistm.close();
			show(pd);

			Watchdog.logString("WritePadCommand:Open file: Done.\n");
		} catch(IOStreamError.FileInputStreamError e) {
			Watchdog.logString("WritePadCommand:Open file: Could not open file\n");
			return -1;
		}
		return 0;
	}
	void test_doc() {
		PlainDocument testDoc = new PlainDocument();
		etxt elem = etxt.from_static("good");
		testDoc.addLine(&elem);
		show(testDoc);
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
#endif
}
