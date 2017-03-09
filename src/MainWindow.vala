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
         * Open existing files
         *
         * @param files the files to open
         */
        public void open (File[] files)
        {
            foreach (var file in files)
            {
                var window = new SchematicWindow.with_file(file);
                window.visible = true;
                var tab = new DocumentTab(window);
                tab.show_all();

                notebook.append_page(window, tab);
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
         * The notebook containing the document windows
         */
        [GtkChild]
        private Gtk.Notebook notebook;


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

            requires(notebook != null)

        {
            var window = new SchematicWindow();
            window.visible = true;
            var tab = new DocumentTab(window);
            tab.show_all();

            notebook.append_page(window, tab);
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

            requires(notebook != null)

        {
            var page_index = notebook.get_current_page();

            if (page_index >= 0)
            {
                var page = notebook.get_nth_page(page_index) as Savable;

                if (page != null)
                {
                    page.save(this);
                }
            }
        }


        /**
         * Save all the open files
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_file_save_all(SimpleAction action, Variant? parameter)

            requires(notebook != null)

        {
            var page_count = notebook.get_n_pages();

            for (var page_index = 0; page_index < page_count; page_index++)
            {
                var page = notebook.get_nth_page(page_index) as Savable;

                if (page != null)
                {
                    page.save(this);
                }
            }
        }


        /**
         * Save the current file with a different filename
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_file_save_as(SimpleAction action, Variant? parameter)

            requires(notebook != null)

        {
            var page_index = notebook.get_current_page();

            if (page_index >= 0)
            {
                var page = notebook.get_nth_page(page_index) as Savable;

                if (page != null)
                {
                    page.save_as(this);
                }
            }
        }
    }
}
