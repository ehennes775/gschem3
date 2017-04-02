namespace Geda3
{
    /**
     * A symbol folder inside a symbol library
     */
    public class KeyFileSymbolFolder
    {
        /**
         * Create a new symbol library based off a key file
         */
        public string id
        {
            get;
            private set;
        }


        /**
         * Create a new symbol library based off a key file
         */
        public File file
        {
            get;
            private set;
        }


        /**
         * Create a new symbol library based off a key file
         */
        public string key
        {
            get;
            private set;
        }


        /**
         * Create a new symbol library based off a key file
         */
        public FileMonitor? monitor
        {
            get;
            private set;
        }


        /**
         * Create a new symbol library based off a key file
         */
        public KeyFileSymbolFolder(File file)
        {
            var file_type = file.query_file_type(
                FileQueryInfoFlags.NONE
                );

            if (file_type != FileType.DIRECTORY)
            {
                // not a directory
            }
        }
    }
}
