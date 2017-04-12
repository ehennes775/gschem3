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
            try
            {
                if (file != null)
                {
                    var file_info = file.query_info(
                        FileAttribute.STANDARD_DISPLAY_NAME,
                        FileQueryInfoFlags.NONE
                        );

                    tab = file_info.get_display_name();
                }
                else
                {
                    tab = "Unknown";
                }
            }
            catch (Error error)
            {
                tab = "Error";
            }
        }
    }
}
