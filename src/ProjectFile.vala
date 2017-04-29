namespace Geda3
{
    /**
     * A file in the project tree
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
         * the persistence layer.
         */
        public bool absolute
        {
            get;
            set;
        }


        /**
         * Indicates this file can be opened
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
            default = true;
        }


        /**
         * {@inheritDoc}
         */
        public bool can_rename
        {
            get;
            protected set;
        }


        /**
         * The underlying file this item refers to
         */
        public File? file
        {
            get;
            set;
            default = null;
        }


        /**
         * A string uniquely identifying the file
         *
         * If this property contains null, then there is no underlying
         * file or an error occured.
         */
        public string? file_id
        {
            get;
            private set;
        }


        /**
         * {@inheritDoc}
         */
        public override ProjectIcon icon
        {
            get;
            protected set;
        }


        /**
         * A unique string identifying this item
         */
        public string key
        {
            get;
            construct;
        }


        /**
         * {@inheritDoc}
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
         * Initialize a new instance with a file
         *
         * @param key A unique string identifying this item
         * @param file The file for this item
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
            request_remove();
        }


        /**
         * {@inheritDoc}
         */
        public void rename(string new_name) throws Error

            requires(file != null)

        {
            var folder = file.get_parent();

            var new_file = folder.get_child_for_display_name(
                new_name
                );

            file.move(
                new_file,
                FileCopyFlags.NO_FALLBACK_FOR_MOVE
                );

            file = new_file;

            request_update();
        }


        /**
         * The attributes needed for the query in on_notify_file
         */
        private static string s_attributes = string.join(
            ",",
            FileAttribute.STANDARD_DISPLAY_NAME,
            FileAttribute.ID_FILE
            );


        /**
         * Signal handler when the file changes
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

                    can_open = true;
                    can_rename = true;
                    icon = ProjectIcon.SCHEMATIC;
                    tab = file_info.get_display_name();
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
