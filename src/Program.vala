namespace Gschem3
{

    public class Program : Gtk.Application
    {
        /**
         * Construct the program
         */
        public Program()
        {
            Object(
                application_id: "com.github.ehennes775.gschem3",
                flags: ApplicationFlags.HANDLES_OPEN
                );
        }


        /**
         * The program entry point
         *
         * @param args the program arguments
         * @return the exit status
         */
        static int main(string[] args)
        {
            return new Program().run(args);
        }


        /**
         * Create a new main window
         */
        protected override void activate()
        {
            try
            {
                var window = new MainWindow();

                return_if_fail(window != null);

                this.add_window(window);

                window.show_all();
            }
            catch (Error error)
            {
                stderr.printf("%s\n", error.message);
            }
        }


        /**
         * Open files along with a new window for each file.
         *
         * @param files The files to open
         * @param hint unused
         */
        protected override void open(File[] files, string hint)
        {
            foreach (var file in files)
            {
                try
                {
                    var window = new MainWindow(file);

                    return_if_fail(window != null);

                    this.add_window(window);

                    window.show_all();
                }
                catch (Error error)
                {
                    stderr.printf("%s\n", error.message);
                }
            }
        }


        /**
         * Called after the applicaton is registered
         */
        protected override void startup()
        {
            base.startup();

            try
            {
                var builder = new Gtk.Builder.from_resource(RESOURCE_NAME);

                menubar = builder.get_object("menubar") as MenuModel;
            }
            catch (Error error)
            {
                stderr.printf("%s\n", error.message);
            }
        }


        /**
         * The the id of the menubar in the resource file
         */
        private const string MENUBAR_ID = "menu";


        /**
         * The resource name for the UI menus.
         */
        private const string RESOURCE_NAME =
            "/com/github/ehennes775/gschem3/Menus.ui.xml";
    }
}
