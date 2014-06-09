using aroop;

/**
 * \ingroup guiimpl
 * \defgroup linuxguiimpl QT based linux GUI Implementation
 */
/** \addtogroup linuxguiimpl
 *  @{
 */
namespace roopkotha.platform {
	[CCode (cname="QTRoopkothaGUICore",has_copy_function=true, free_function="qt_impl_guicore_destroy", cheader_filename = "shotodol_platform_gui.h")]
	public class GUICorePlatformImpl {
		[CCode (cname="qt_impl_guicore_create")]
		public static GUICorePlatformImpl create();
		[CCode (cname="qt_impl_guicore_step")]
		public int step();
		[CCode (cname="qt_impl_push_task")]
		public void pushTask(etxt*task);
		[CCode (cname="qt_impl_pop_task_as")]
		public void popTaskAs(etxt*task);
	}
}


/** @} */
