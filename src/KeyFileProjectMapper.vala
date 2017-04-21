namespace Geda3
{
    /**
     *
     */
    public class KeyFileProjectStorage : ProjectStorage
    {
        /**
         * {@inheritDoc}
         */
        public override File folder
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
                s_schematic_key = new Regex("^Schematic");
            }
            catch (Error error)
            {
                s_schematic_key = null;
            }
        }


        /**
         * Initialize the instance
         */
        construct
        {
            m_key_file = new KeyFile();
        }


        /**
         *
         *
         * @param file
         */
        public KeyFileProjectStorage.open(File file) throws Error
        {
            m_file = file;

            m_key_file.load_from_file(
                m_file.get_path(),
                KeyFileFlags.KEEP_COMMENTS | KeyFileFlags.KEEP_TRANSLATIONS
                );

            folder = m_file.get_parent();
        }


        /**
         * {@inheritDoc}
         */
        public override ProjectItem[] get_files()

            requires(m_key_file != null)
            ensures(result != null)

        {
            var files = new Gee.ArrayList<ProjectItem>();
            var keys = get_schematic_keys();

            foreach (var key in keys)
            {
                var path = m_key_file.get_string(
                    SCHEMATIC_GROUP,
                    key
                    );

                var abs_path = Path.build_filename(
                    folder.get_path(),
                    path
                    );

                files.add(new ProjectFile(
                    File.new_for_path(abs_path)
                    ));
            }

            return files.to_array();
        }


        /**
         * {@inheritDoc}
         */
        public override ProjectItem insert_file(File file)

            ensures(result != null)

        {
            return new ProjectFile(file);
        }


        /**
         * {@inheritDoc}
         */
        public override void save()

            requires(m_file != null)
            requires(m_key_file != null)

        {
            m_key_file.save_to_file(m_file.get_path());
        }


        /**
         *
         *
         * @return A list of key names that contain schematic paths
         */
        private string[] get_schematic_keys()

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


        /**
         * The group name in the key file that contains schematics
         */
        private const string SCHEMATIC_GROUP = "Schematics";


        /**
         * Checks if a key represents a schematic file
         */
        private static Regex s_schematic_key;


        private File m_file;
        

        /**
         * The underlying key file used for persistence
         */
        private KeyFile m_key_file;
    }
}
