namespace Geda3
{
    /**
     * Represents a folder in the symbol library tree
     */
    public class LibraryFolder : LibraryItem
    {
        /**
         * {@inheritDoc}
         *
         * This property is set by the notify signal handler of the
         * {@link file} property. Changing the {@link file} property
         * will update this value.
         */
        public override string? description
        {
            get;
            protected set;
            default = null;
        }


        /**
         * The underlying file this item represents
         */
        public File? file
        {
            get;
            set;

            // Setting the default to null allows the signal handlers
            // to run and establish initial values for other
            // properties.
            default = null;
        }


        /**
         * A string uniquely identifying the file
         *
         * If this property contains null, then there is no underlying
         * file or an error occured.
         *
         * This property is set by the notify signal handler of the
         * {@link file} property. Changing the {@link file} property
         * will update this value.
         */
        public string? file_id
        {
            get;
            private set;
        }


        /**
         * {@inheritDoc}
         *
         * This property is set by the notify signal handler of the
         * {@link file} property. Changing the {@link file} property
         * will update this value.
         */
        public override ProjectIcon icon
        {
            get;
            protected set;
        }


        /**
         * A monitor for changes to the directory
         *
         * This property is set by the notify signal handler of the
         * {@link file} property. Changing the {@link file} property
         * will update this value.
         */
        public FileMonitor? monitor
        {
            get
            {
                return b_monitor;
            }
            private set
            {
                if (b_monitor != null)
                {
                    b_monitor.changed.disconnect(on_changed);
                }

                b_monitor = value;

                if (b_monitor != null)
                {
                    b_monitor.changed.connect(on_changed);
                }
            }
        }


        /**
         * {@inheritDoc}
         *
         * To facilitate renaming the file, this property contains the
         * {@link GLib.FileAttribute.STANDARD_EDIT_NAME}.
         *
         * This property is set by the notify signal handler of the
         * {@link file} property. Changing the {@link file} property
         * will update this value.
         */
        public override string tab
        {
            get;
            protected set;
        }


        /**
         * Initialize the instance
         */
        construct
        {
            notify["file"].connect(on_notify_file);
        }


        /**
         * Initialize an instance
         *
         * @param file The underlying file this item represents
         */
        public LibraryFolder(File file)
        {
            Object(
                file : file
                );
        }


        /**
         *
         *
         */
        public override void perform_refresh(SymbolLibrary library)
        {
            var node = library.find_item(this);
            return_if_fail(node != null);

            var files = get_files();
            var iter = library.nth_child(node, 0);

            while (iter != null)
            {
                var item = library.get_item(iter);
                var file_item = item as LibraryFile;

                if ((file_item == null) || (file_item.file == null))
                {
                    iter = library.next_sibling(iter);
                    continue;
                }

                var basename = file_item.file.get_basename();

                if (files.contains(basename))
                {
                    files.remove(basename);
                }
                else
                {
                    library.remove_node(iter);
                }

                iter = library.next_sibling(iter);
            }

            foreach (var basename in files)
            {
                var new_file = file.resolve_relative_path(basename);

                request_insertion(
                    this,
                    new LibraryFile(new_file)
                    );
            }
        }


        /**
         * Backing store for the directory monitor 
         */
        private FileMonitor? b_monitor = null;


        /**
         * The attributes needed for the file info query in
         * {@link on_notify_file()}.
         */
        private static string s_attributes = string.join(
            ",",
            FileAttribute.ID_FILE,
            FileAttribute.STANDARD_EDIT_NAME
            );


        /**
         * The glob pattern for symbol files
         */
        private static PatternSpec s_pattern = new PatternSpec(
            "*.sym"
            );


        /**
         * Process a file or folder creation
         *
         * @param created_file The file or folder that was created
         */
        private void file_created(File created_file)
        {
            var file_type = created_file.query_file_type(
                FileQueryInfoFlags.NONE
                );

            if (file_type == FileType.REGULAR)
            {
                var basename = created_file.get_basename();
                var match = s_pattern.match_string(basename);

                if (match)
                {
                    request_insertion(
                        this,
                        new LibraryFile(created_file)
                        );
                }
            }
            else if (file_type == FileType.DIRECTORY)
            {
                // process a possible change to this folder
            }
        }


        /**
         * Process a file or folder deletion
         *
         * @param deleted_file The file or folder that was deleted
         */
        private void file_deleted(File deleted_file)
        {
            stdout.printf("on_changed_deleted\n");

            if (file.query_exists())
            {
                // this folder was lost
            }

            request_refresh(this);
        }


        /**
         * A signal handler for
         *
         * When a file is added to the folder, a CREATED event will
         * occur.
         *
         * When a file is deleted from the folder, a DELETE event will
         * occur.
         *
         * When a file is renamed in the folder, a DELETE event followed
         * by a CREATED event will occur.
         *
         * @param a
         * @param b
         * @param event
         */
        private void on_changed(File a, File? b, FileMonitorEvent event)
        {
            switch (event)
            {
                case FileMonitorEvent.CREATED:
                    warn_if_fail(b != null);
                    file_created(a);
                    break;

                case FileMonitorEvent.DELETED:
                    warn_if_fail(b != null);
                    file_deleted(a);
                    break;

                default:
                    break;
            }
        }


        /**
         * A signal handler when the {@link file} property changes
         *
         * @param param unused
         */
        private void on_notify_file(ParamSpec param)
        {
            try
            {
                if (file != null)
                {
                    var file_info = file.query_info(
                        s_attributes,
                        FileQueryInfoFlags.NONE
                        );

                    file_id = file_info.get_attribute_string(
                        FileAttribute.ID_FILE
                        );

                    icon = ProjectIcon.GREEN_FOLDER;
                    tab = file_info.get_edit_name();

                    monitor = file.monitor_directory(
                        FileMonitorFlags.NONE
                        );
                }
                else
                {
                    file_id = null;
                    icon = ProjectIcon.BLANK;
                    tab = "Unknown";
                    monitor = null;
                }
            }
            catch (Error error)
            {
                file_id = null;
                icon = ProjectIcon.MISSING;
                monitor = null;

                if (file != null)
                {
                    tab = file.get_basename();
                }
                else
                {
                    tab = "Error";
                }
            }
        }


        /**
         * Get the basenames of all the symbol files in this folder
         *
         * @return A set of all the basenames
         */
        private Gee.Set<string> get_files()
        {
            var basename_set = new Gee.HashSet<string>();

            try
            {
                var iter = file.enumerate_children(
                    "standard::*",
                    FileQueryInfoFlags.NONE
                    );

                var info = iter.next_file();

                while (info != null)
                {
                    var basename = info.get_name();
                    var match = s_pattern.match_string(basename);

                    if (match)
                    {
                        var file_type = info.get_file_type();

                        if (file_type == FileType.REGULAR)
                        {
                            basename_set.add(basename);
                        }
                    }

                    info = iter.next_file();
                }
            }
            catch (Error error)
            {
            }

            return basename_set;
        }
    }
}

