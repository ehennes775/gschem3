namespace Geda3
{
    /**
     * Represents a file in the project tree
     */
    public class LibraryFile : LibraryItem,
        RenamableItem
    {
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
         * Initialize the class
         */
        static construct
        {
            try
            {
                s_regex = new Regex(
                    "description=(.*)"
                    );
            }
            catch (Error error)
            {
                assert_not_reached();
            }
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
        public LibraryFile(File file)
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

                // request_update();
            }
        }


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
         * For extracting the description from a symbol file
         */
        private static Regex s_regex;


        /**
         * The priority to use for fetching the description in the
         * background.
         */
        private const int FETCH_PRIORITY = Priority.LOW;


        /**
         * For cancelling the background async function
         */
        private Cancellable m_cancel = null;


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

                    icon = ProjectIcon.SYMBOL;
                    tab = file_info.get_edit_name();

                    fetch_description.begin();
                }
                else
                {
                    can_open = false;
                    can_rename = false;
                    file_id = null;
                    icon = ProjectIcon.BLANK;
                    tab = "Unknown";
                }
            }
            catch (Error error)
            {
                can_open = false;
                can_rename = false;
                file_id = null;
                icon = ProjectIcon.MISSING;

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
         * Fetch the description from the symbol file
         */
        private async void fetch_description()
        {
            try
            {
                if (m_cancel != null)
                {
                    m_cancel.cancel();
                }

                m_cancel = new Cancellable();

                description = null;

                var stream = yield file.read_async(FETCH_PRIORITY, m_cancel);
                var data = new DataInputStream(stream);
                var line = yield data.read_line_async(FETCH_PRIORITY, m_cancel);

                while ((line != null) && !m_cancel.is_cancelled())
                {
                    MatchInfo info;

                    var success = s_regex.match(line, 0, out info);

                    if (success)
                    {
                        description = info.fetch(1) ?? "";

                        break;
                    }

                    line = yield data.read_line_async(FETCH_PRIORITY, m_cancel);
                }
            }
            catch (Error error)
            {
                warning(error.message);
            }
        }
    }
}
