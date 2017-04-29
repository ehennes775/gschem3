namespace Geda3
{
    /**
     * Represents a file in the project tree
     */
    public class ProjectFile : ProjectItem,
        RemovableItem,
        RenamableItem
    {
        /**
         * Requests removal from the persistence layer
         */
        public signal void request_remove();


        /**
         * Requests an update from the persistence layer
         */
        public signal void request_update();


        /**
         * Indicates the file was stored with an absolute path in
         * the persistence layer
         */
        public bool absolute
        {
            get;
            set;
        }


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
         */
        public bool can_remove
        {
            get;
            protected set;

            // Currently, project file items are always removable. This
            // may change in the future when the persistence layer
            // supports read-only projects.
            default = true;
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
         * Provides a unique string identifying this item to the
         * persistence layer
         *
         * This value must remain the same througout the lifespan of
         * this object.
         */
        public string key
        {
            get;
            construct;
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
         * @param key A unique string identifying this item to the
         * persistence layer
         * @param file The underlying file this item represents
         * @param absolute The persistence layer uses an abolute path
         */
        public ProjectFile(string key, File file, bool absolute)
        {
            Object(
                key : key,
                file : file,
                absolute : absolute
                );
        }


        /**
         * {@inheritDoc}
         */
        public void remove()
        {
            warn_if_fail(can_remove);

            request_remove();
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

                request_update();
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

                    icon = ProjectIcon.SCHEMATIC;
                    tab = file_info.get_edit_name();
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
    }
}
