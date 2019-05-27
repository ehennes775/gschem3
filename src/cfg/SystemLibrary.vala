namespace Geda3
{
    /**
     * Configuration for the system symbol library
     *
     * (This class will likely be extended for other configuration
     * items.)
     */
    public class SystemLibrary : Object,
        LibraryContributor
    {
        /**
         * {@inheritDoc}
         */
        public string contributor_name
        {
            get
            {
                return CONTRIBUTOR_NAME;
            }
        }


        /**
         * Initialize the instance
         */
        public SystemLibrary()
        {
            m_key_file = new KeyFile();

            try
            {
                m_key_file.load_from_file(
                    "system.configuration",
                    KeyFileFlags.NONE
                    );
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         * {@inheritDoc}
         */
        public Gee.Collection<LibraryEntry> load_library_entries()
        {
            return LibraryEntry.read(
                m_key_file
                );
        }


        /**
         * The name of this configuration shown in the symbol widget
         */
        private const string CONTRIBUTOR_NAME = "System Library";


        /**
         * The underlying key file
         */
        private KeyFile m_key_file;
    }
}
