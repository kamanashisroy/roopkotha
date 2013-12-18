using aroop;
using shotodol;
using roopkotha;

public class onubodh.WritePadCommand : M100Command {
	etxt prfx;
	enum Options {
		INFILE = 1,
		OUTFILE,
	}
	public WritePadCommand() {
		base();
		etxt input = etxt.from_static("-i");
		etxt input_help = etxt.from_static("Input file");
		etxt output = etxt.from_static("-o");
		etxt output_help = etxt.from_static("Output file");
		addOption(&input, M100Command.OptionType.TXT, Options.INFILE, &input_help);
		addOption(&output, M100Command.OptionType.TXT, Options.OUTFILE, &output_help); 
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("writepad");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		int ecode = 0;
		SearchableSet<txt> vals = SearchableSet<txt>();
		parseOptions(cmdstr, &vals);
		do {
			test_ui2();
			container<txt>? mod;
			if((mod = vals.search(Options.INFILE, match_all)) == null) {
				break;
			}
			unowned txt infile = mod.get();
			if((mod = vals.search(Options.OUTFILE, match_all)) == null) {
				break;
			}
			unowned txt outfile = mod.get();
			bye(pad, true);
			return 0;
		} while(false);
		bye(pad, false);
		return 0;
	}

	GUICoreImpl impl;
	//Turbine gtb;
	void test_ui() {
		print("test gui started .\n");
		impl = new GUICoreImpl();
		//gtb = new Turbine();
		//gtb.gearup(impl);
		//xultb_guicore_system_init(&argc, argv);

		etxt title = etxt.from_static("Test");
		etxt dc = etxt.from_static("quit");

		SimpleListView lv = new SimpleListView(&title, &dc);	

		Watchdog.logString("WritePadCommand:test_ui:adding list item\n");
		etxt elem = etxt.from_static("good");
		ListViewItemComplex item = new ListViewItemComplex.createLabel(&elem, null);
		lv.setListViewItem(0, item);

		//elem = xultb_str_alloc_static("very good");
		//item = xultb_list_item_createLabel(elem, NULL);
		//opp_indexed_list_set(&list->_items, 1, item);

		MainTurbine.gearup(impl);
		lv.show();
		Watchdog.logString("WritePadCommand:test_ui:list show\n");
		//gtb.startup();
	}

	void test_ui2() {
		print("test gui started .\n");
		impl = new GUICoreImpl();

		etxt title = etxt.from_static("Test");
		etxt dc = etxt.from_static("quit");

		DocumentView lv = new DocumentView(&title, &dc);	
		PlainDocument pd = new PlainDocument();

		etxt elem = etxt.from_static("good");
		pd.addLine(&elem);
		lv.setDocument(pd);

		MainTurbine.gearup(impl);
		lv.show();
		Watchdog.logString("WritePadCommand:test_ui:list show\n");
	}
}
