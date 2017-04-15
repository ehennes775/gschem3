namespace Geda3
{
    /**
     * A file in the project tree
     */
    public class ProjectFile : ProjectItem
    {
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
         * @param file The file for this item
         */
        public ProjectFile(File file)
        {
            Object(
                file : file
                );
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

                    icon = ProjectIcon.SCHEMATIC;
                    tab = file_info.get_display_name();
                }
                else
                {
                    file_id = null;
                    icon = ProjectIcon.BLANK;
                    tab = "Unknown";
                }
            }
            catch (Error error)
            {
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
