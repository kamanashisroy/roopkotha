using aroop;

/**
 * \ingroup guiimpl
 * \defgroup linuxguiimpl QT,X11 based linux GUI Implementation
 */
/** \addtogroup linuxguiimpl
 *  @{
 */
namespace roopkotha.platform {
	[CCode (cname="PlatformRoopkothaGUICore",has_copy_function=true, free_function="platform_impl_guicore_destroy", cheader_filename = "shotodol_platform_gui.h")]
	public class GUICorePlatformImpl {
		[CCode (cname="platform_impl_guicore_create")]
		public static GUICorePlatformImpl create();
		[CCode (cname="platform_impl_guicore_step")]
		public int step();
		[CCode (cname="platform_impl_push_task")]
		public void pushTask(extring*task);
		[CCode (cname="platform_impl_pop_task_as")]
		public void popTaskAs(extring*task);
	}
}


/** @} */
