namespace Gschem3
{
    public class MainWindow : Gtk.ApplicationWindow
    {
        /**
         * The name of the program as it appears in the title bar
         */
        [CCode(cname = "PACKAGE_NAME")]
        private static extern const string PROGRAM_TITLE;


        /**
         * Construct the main window
         *
         * @param the file to open in the new window
         */
        public MainWindow(File? file = null)
        {
        }
    }
}
