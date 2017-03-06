namespace Gschem3
{
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/MainWindow.ui.xml")]
    public class MainWindow : Gtk.ApplicationWindow
    {
        /**
         * The name of the program as it appears in the title bar
         */
        [CCode(cname = "PACKAGE_NAME")]
        private static extern const string PROGRAM_TITLE;


        /**
         * Initialize the instance
         */
        construct
        {
            delete_event.connect(on_delete_event);
            add_action_entries(action_entries, this);
        }


        /**
         * Construct the main window
         *
         * @param the file to open in the new window
         */
        public MainWindow(File? file = null)
        {
        }


        /**
         *
         */
        public void open (File[] files)
        {
            stdout.printf("Opening files:\n");
            
            foreach (var file in files)
            {
                stdout.printf("    %s\n", file.get_path());
            }
        }

        /**
         * Organized from most frequently used to least frequently used
         */
        private const ActionEntry[] action_entries =
        {
            { "file-open", on_file_open, null, null, null },
            { "file-new", on_file_new, null, null, null },
            { "file-save", on_file_save, null, null, null },
            { "file-save-all", on_file_save_all, null, null, null },
            { "file-save-as", on_file_save_as, null, null, null }
        };


        /**
         * An event handler when the user selects the delete button
         *
         * @return true Abort the destruction process
         * @return false Continue with the destruction process
         */
        private bool on_delete_event(Gdk.EventAny event)
        {
            return false;
        }


        /**
         * Create a new file
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_file_new(SimpleAction action, Variant? parameter)
        {
            stdout.printf("on_file_new\n");
        }


        /**
         * Open existing file(s)
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_file_open(SimpleAction action, Variant? parameter)
        {
            var dialog = new Gtk.FileChooserDialog(
                "Select File",
                this,
                Gtk.FileChooserAction.OPEN,
                "_Cancel", Gtk.ResponseType.CANCEL,
                "_Open", Gtk.ResponseType.ACCEPT
                );

            dialog.select_multiple = true;

            var response = dialog.run();

            if (response == Gtk.ResponseType.ACCEPT)
            {
                var files = new Gee.ArrayList<File>();

                dialog.get_files().foreach((file) => { files.add(file); });

                open(files.to_array());
            }

            dialog.close();
        }


        /**
         * Save the current file
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_file_save(SimpleAction action, Variant? parameter)
        {
            stdout.printf("on_file_save\n");
        }


        /**
         * Save all the open files
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_file_save_all(SimpleAction action, Variant? parameter)
        {
            stdout.printf("on_file_save_all\n");
        }


        /**
         * Save the current file with a different filename
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_file_save_as(SimpleAction action, Variant? parameter)
        {
            stdout.printf("on_file_save_as\n");
        }
    }
}
