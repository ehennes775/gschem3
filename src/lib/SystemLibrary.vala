namespace Geda3
{
    /**
     *
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
            var libraries = new Gee.ArrayList<LibraryEntry>();

            foreach (var group_name in m_key_file.get_groups())
            {
                try
                {
                    if (group_name.has_suffix(LIBRARY_SUFFIX))
                    {
                        var entry = new LibraryEntry()
                        {
                            id = group_name,
                            name = m_key_file.get_string(group_name, NAME_KEY),
                            folder = m_key_file.get_string(group_name, FOLDER_KEY),
                            description = m_key_file.get_string(group_name, DESCRIPTION_KEY)
                        };

                        libraries.add(entry);
                    }
                }
                catch (Error error)
                {
                    warn_if_reached();
                }
            }

            return libraries;
        }


        /**
         *
         */
        private const string CONTRIBUTOR_NAME = "System Library";


        /**
         *
         */
        private KeyFile m_key_file;


        private const string DESCRIPTION_KEY = "description";

        private const string FOLDER_KEY = "folder";

        private const string LIBRARY_SUFFIX = ".library";

        private const string NAME_KEY = "name";
    }
}
