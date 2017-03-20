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

            // Setup drag and drop

            var targets = new Gtk.TargetList(null);
            targets.add_uri_targets(TargetInfo.URI_LIST);

            Gtk.drag_dest_set(
                this,
                Gtk.DestDefaults.ALL,
                target_entries,
                Gdk.DragAction.MOVE
                );

            Gtk.drag_dest_set_target_list(this, targets);

            drag_data_received.connect(on_data_received);
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
         * This functions sets current notebook page to the page
         * containing last document succesfully opened.
         *
         * @param files the files to open
         */
        public void open (File[] files)

            requires (notebook != null)

        {
            Gtk.Widget? last_window = null;

            foreach (var file in files)
            {
                try
                {
                    var window = find_by_file(file);

                    if (window == null)
                    {
                        window = new SchematicWindow.with_file(file);
                        window.visible = true;
                        var tab = new DocumentTab(window);
                        tab.show_all();

                        notebook.append_page(window, tab);
                    }
                    
                    last_window = window;
                }
                catch (Error error)
                {
                    ErrorDialog.show_with_file(this, error, file);
                }
            }

            if (last_window != null)
            {
                var page_index = notebook.page_num(last_window);

                if (page_index >= 0)
                {
                    notebook.set_current_page(page_index);
                }
                else
                {
                    warn_if_reached();
                }
            }
        }


        /**
         * Identifies the drop operation
         */
        private enum TargetInfo
        {
            URI_LIST,
            COUNT
        }


        /**
         * Organized from most frequently used to least frequently used
         */
        private const ActionEntry[] action_entries =
        {
            { "file-save", on_file_save, null, null, null },
            { "file-save-all", on_file_save_all, null, null, null },
            { "file-save-as", on_file_save_as, null, null, null },
            { "file-open", on_file_open, null, null, null },
            { "file-new", on_file_new, null, null, null },
            { "file-reload", on_file_reload, null, null, null }
        };


        /**
         * The drag and drop targets
         *
         * Currently, an empty list since drag_dest_set cannot accept
         * a null pointer.
         */
        private const Gtk.TargetEntry[] target_entries =
        {
        };


        /**
         * The notebook containing the document windows
         */
        [GtkChild]
        private Gtk.Notebook notebook;


        /**
         * Find the document window that contains a file
         * 
         * @param file The file to search for
         * @return The document window containing the file, or null if
         * not found.
         */
        private DocumentWindow? find_by_file(File file) throws Error

            requires(notebook != null)

        {
            var file_info = file.query_info(
                FileAttribute.ID_FILE,
                FileQueryInfoFlags.NONE
                );

            var file_id = file_info.get_attribute_string(
                FileAttribute.ID_FILE
                );

            if (file_id == null)
            {
                return null;
            }

            var page_count = notebook.get_n_pages();

            for (var page_index = 0; page_index < page_count; page_index++)
            {
                var window = notebook.get_nth_page(page_index) as DocumentWindow;

                if (window == null)
                {
                    continue;
                }

                var fileable = window as Fileable;

                if (fileable == null)
                {
                    continue;
                }

                if (file_id == fileable.file_id)
                {
                    return window;
                }
            }

            return null;
        }


        /**
         * An event handler for drag and drop data received
         *
         * @param context the drag context
         * @param x the x coordinate of the drop location
         * @param y the y coordinate of the drop location
         * @param data the selection data
         * @param info the number registered in the target list
         * @param timestamp when the drop operation occured
         */
        private void on_data_received(
            Gdk.DragContext context,
            int x,
            int y,
            Gtk.SelectionData data,
            uint info,
            uint timestamp
            )

            requires (info < TargetInfo.COUNT)

        {
            if (info == TargetInfo.URI_LIST)
            {
                var files = new Gee.ArrayList<File>();
                var uris = data.get_uris();

                foreach (var uri in uris)
                {
                    files.add(File.new_for_uri(uri));
                }

                open(files.to_array());
            }
        }


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
         * Reload the current file
         *
         * @param action the action that activated this function call
         * @param parameter unused
         */
        private void on_file_reload(SimpleAction action, Variant? parameter)

            requires(notebook != null)

        {
            var page_index = notebook.get_current_page();

            if (page_index >= 0)
            {
                var page = notebook.get_nth_page(page_index) as Reloadable;

                if (page != null)
                {
                    try
                    {
                        page.reload(this);
                    }
                    catch (Error error)
                    {
                        ErrorDialog.show_with_file(this, error, page.file);
                    }
                }
            }
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
                    try
                    {
                        page.save(this);
                    }
                    catch (Error error)
                    {
                        ErrorDialog.show_with_file(this, error, page.file);
                    }
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
                    try
                    {
                        page.save(this);
                    }
                    catch (Error error)
                    {
                        ErrorDialog.show_with_file(this, error, page.file);
                    }
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
                    try
                    {
                        page.save_as(this);
                    }
                    catch (Error error)
                    {
                        ErrorDialog.show_with_file(this, error, page.file);
                    }
                }
            }
        }
    }
}
