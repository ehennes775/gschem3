namespace Geda3
{
    /**
     * Represents a folder in the project tree
     */
    public class LibraryFolder : LibraryItem,
        RenamableItem
    {
        public delegate void Updater(Gee.List<LibraryItem> items);

        /**
         * Indicates this file can be opened
         *
         * This property is set by the notify signal handler of the
         * {@link file} property. Changing the {@link file} property
         * will update this value.
         */
        public bool can_open
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
        public bool can_rename
        {
            get;
            protected set;
        }


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
         * {@inheritDoc}
         *
         * @param new_name The new filename, in UTF-8. This value can
         * originate from UI widgets.
         */
        public void rename(string new_name) throws Error

            requires(file != null)

        {
            warn_if_fail(can_rename);

            if (new_name != tab)
            {
                file = file.set_display_name(new_name);

                //request_update();
            }
        }


        /**
         * Backing store for the directory monitor 
         */
        private FileMonitor? b_monitor = null;


        /**
         *
         */
        private PatternSpec m_pattern = new PatternSpec("*.sym");


        /**
         * The attributes needed for the file info query in
         * {@link on_notify_file()}.
         */
        private static string s_attributes = string.join(
            ",",
            FileAttribute.ACCESS_CAN_READ,
            FileAttribute.ACCESS_CAN_RENAME,
            FileAttribute.ID_FILE,
            FileAttribute.STANDARD_EDIT_NAME
            );


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
         * @param param unused
         */
        private void on_changed(File a, File? b, FileMonitorEvent event)
        {
            switch (event)
            {
                case FileMonitorEvent.CREATED:
                    on_changed_created(a);
                    break;

                case FileMonitorEvent.DELETED:
                    on_changed_deleted(a);
                    break;

                default:
                    break;
            }
        }


        /**
         *
         *
         * @param file The file that was created
         */
        private void on_changed_created(File file)
        {
            var file_type = file.query_file_type(
                FileQueryInfoFlags.NONE
                );

            if (file_type == FileType.REGULAR)
            {
                var basename = file.get_basename();

                var match = m_pattern.match_string(basename);

                if (match)
                {
                    request_insertion(
                        this,
                        new LibraryFile(file)
                        );
                }
            }
        }


        /**
         *
         * @param file The file that was deleted
         */
        private void on_changed_deleted(File file)
        {
            Updater updater = (items) =>
            {
                foreach (var item in items)
                {
                    stdout.printf("A\n");
                    
                    var file_item = item as LibraryFile;

                    if (file_item == null)
                    {
                        continue;
                    }

                    stdout.printf(@"B $(file.get_path())\n");

                    if (file.equal(file_item.file))
                    {
                        stdout.printf("C\n");

                        request_removal(item);

                        stdout.printf("D\n");
                    }
                }
            };

            request_update(this, (void*) updater);
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

                    can_open = file_info.get_attribute_boolean(
                        FileAttribute.ACCESS_CAN_READ
                        );

                    can_rename = file_info.get_attribute_boolean(
                        FileAttribute.ACCESS_CAN_RENAME
                        );

                    icon = ProjectIcon.GREEN_FOLDER;
                    tab = file_info.get_edit_name();

                    monitor = file.monitor_directory(
                        FileMonitorFlags.NONE
                        );
                }
                else
                {
                    can_open = false;
                    can_rename = false;
                    file_id = null;
                    icon = ProjectIcon.BLANK;
                    tab = "Unknown";
                    monitor = null;
                }
            }
            catch (Error error)
            {
                can_open = false;
                can_rename = false;
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

            enumerate();
        }


        /**
         * A function for populating the folder with test data
         */
        public Gee.ArrayList<LibraryItem> enumerate()

            requires(file != null)

        {
            var list = new Gee.ArrayList<LibraryItem>();

            try
            {
                var iter = file.enumerate_children(
                    "standard::*",
                    FileQueryInfoFlags.NOFOLLOW_SYMLINKS
                    );

                var info = iter.next_file();

                while (info != null)
                {
                    stdout.printf("thsi = %s\n", info.get_name());
                    
                    if (m_pattern.match_string(info.get_name()))
                    {
                        var file1 = file.resolve_relative_path(info.get_name());

                        list.add(new LibraryFile(file1));
                    }
                    
                    info = iter.next_file();
                }
            }
            catch (Error error)
            {
            }

            return list;
        }
    }
}

