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
         */
        public string? file_id
        {
            get;
            set;
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
         * Signal handler when the file changes
         *
         * @param param unused
         */
        private void on_notify_file(ParamSpec param)
        {
            string attributes = string.join(
                ",",
                FileAttribute.STANDARD_DISPLAY_NAME,
                FileAttribute.ID_FILE
                );

            try
            {
                if (file != null)
                {
                    var file_info = file.query_info(
                        attributes,
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
