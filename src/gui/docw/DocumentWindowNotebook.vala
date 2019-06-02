namespace Gschem3
{
    /**
     * A widget providing a tabbed view of the open documents
     */
    //[GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/MainWindow.ui.xml")]
    public class DocumentWindowNotebook : Gtk.Notebook,
        DocumentSelector
    {
        /**
         * A delegate for creating a document window with a file
         *
         * This delegate allows this class to check for duplicate
         * documents before creating the document window.
         */
        public delegate DocumentWindow WindowCreateFunc(File file);


        /**
         * The current document window
         *
         * If no tab is currently selected, or the selected tab does
         * not represent a document window, or no tab is current, this
         * property contains null.
         */
        public DocumentWindow? current_document_window
        {
            get;
            protected construct set;
            default = null;
        }


        /**
         * Initialize the instance
         */
        construct
        {
            switch_page.connect(on_switch_page);
        }


        /**
         * Add a document window to the notebook
         *
         * This version does not check if a window with a given file
         * is already open.
         *
         * @param windows The document window to add to the notebook
         */
        public void add_document_window(DocumentWindow window)
        {
            add_tabbed_window(window);

            select_window(window);
        }


        /**
         * Add a document window to the notebook
         *
         * This version ensures duplicate files are not added to the
         * notebook.
         *
         * @param file The file associated with the new window
         * @param create A delegate to create a new window
         */
        public void add_document_window_using_file(
            File file,
            WindowCreateFunc create
            )
        {
            var files = new File[]
            {
                file
            };

            add_document_windows_using_files(files, create);
        }


        /**
         * Add multiple document windows to the notebook
         *
         * This version does not check if a window with a given file
         * is already open.
         *
         * @param windows The document windows to add to the notebook
         */
        public void add_document_windows(DocumentWindow[] windows)
        {
            DocumentWindow? last_window = null;

            foreach (var window in windows)
            {
                add_tabbed_window(window);

                last_window = window;
            }

            if (last_window != null)
            {
                select_window(last_window);
            }
        }


        /**
         * Add multiple document windows to the notebook
         *
         * This version ensures duplicate files are not added to the
         * notebook.
         *
         * @param file The files associated with new windows
         * @param create A delegate to create a new window
         */
        public void add_document_windows_using_files(
            File[] files,
            WindowCreateFunc create
            )
        {
            DocumentWindow? last_window = null;

            foreach (var file in files)
            {
                var existing = find_by_file(file);

                if (existing == null)
                {
                    var window = create(file);

                    add_tabbed_window(window);

                    last_window = window;
                }
                else
                {
                    last_window = existing;
                }
            }

            if (last_window != null)
            {
                select_window(last_window);
            }
        }


        /**
         * Find the document window that contains a file
         *
         * @param file The file to search for
         * @return The document window containing the file, or null if
         * not found.
         */
        private DocumentWindow? find_by_file(File file) throws Error
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

            var page_count = get_n_pages();

            for (var page_index = 0; page_index < page_count; page_index++)
            {
                var window = get_nth_page(page_index) as DocumentWindow;

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
         * Create a document tab and add the pair to the notebook
         *
         * @param window The document window to add to the notebook
         */
        private void add_tabbed_window(DocumentWindow window)
        {
            window.show_all();
            var tab = new DocumentTab(window);
            tab.show_all();

            append_page(window, tab);
        }


        /**
         * Signal handler for notebook page changes
         *
         * @param page The widget representing the page
         * @param number The page number
         */
        private void on_switch_page(Gtk.Widget page, uint number)
        {
            current_document_window = page as DocumentWindow;
        }


        /**
         * Select the current document window
         *
         * @param window The document window to select as current
         */
        private void select_window(DocumentWindow window)
        {
            var page_count = get_n_pages();

            for (var page_index = 0; page_index < page_count; page_index++)
            {
                var temp = get_nth_page(page_index) as DocumentWindow;

                if (window == temp)
                {
                    set_current_page(page_index);

                    break;
                }
            }
        }
    }
}
