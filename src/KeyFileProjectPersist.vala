namespace Geda3
{
    /**
     *
     */
    public class KeyFileProjectPersist : ProjectMapper
    {
        /**
         * Initialize the class
         */
        static construct
        {
            try
            {
                s_schematic_key = new Regex("^Schematic");
            }
            catch (Error error)
            {
                s_schematic_key = null;
            }
        }


        /**
         *
         *
         * @param file
         */
        KeyFileProjectPersist.open(File file) throws Error
        {
            m_key_file.load_from_file(
                file.get_path(),
                KeyFileFlags.KEEP_COMMENTS | KeyFileFlags.KEEP_TRANSLATIONS
                );
        }


        /**
         * {@inheritDoc}
         */
        public override void delete_schematic(string key) throws MapError

            requires(m_key_file != null)

        {
            try
            {
                m_key_file.remove_key(SCHEMATIC_GROUP, key);
            }
            catch (KeyFileError error)
            {
                
            }
        }


        /**
         *
         *
         * @return A list of key names that contain schematic paths
         */
        public string[] get_schematic_keys()

            requires(m_key_file != null)
            requires(s_schematic_key != null)

        {
            var output_keys = new Gee.ArrayList<string>();

            try
            {
                var input_keys = m_key_file.get_keys(SCHEMATIC_GROUP);

                foreach (var key in input_keys)
                {
                    if (s_schematic_key.match(key))
                    {
                        output_keys.add(key);
                    }
                }
            }
            catch (Error error)
            {
            }

            return output_keys.to_array();
        }


        public override void save()
        {
        }


        /**
         * The group name in the key file that contains schematics
         */
        private const string SCHEMATIC_GROUP = "Schematics";


        /**
         * Checks if a key represents a schematic file
         */
        private static Regex s_schematic_key;


        /**
         * The underlying key file used for persistence
         */
        private KeyFile m_key_file;
    }
}
