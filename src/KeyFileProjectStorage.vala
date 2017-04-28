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
         * {@inheritDoc}
         */
        public override File file
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
                s_schematic_key = new Regex(
                    @"^$SCHEMATIC_PREFIX\\."
                    );
            }
            catch (Error error)
            {
                critical(error.message);
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
            this.file = file;
        }


        /**
         * {@inheritDoc}
         */
        public override ProjectFile[] get_files()

            requires(m_key_file != null)
            ensures(result != null)

        {
            var files = new Gee.ArrayList<ProjectFile>();

            try
            {
                var keys = get_schematic_keys();

                foreach (var key in keys)
                {
                    try
                    {
                        var path = m_key_file.get_string(
                            SCHEMATIC_GROUP,
                            key
                            );

                        if (!Path.is_absolute(path))
                        {
                            path = Path.build_filename(
                                folder.get_path(),
                                path
                                );
                        }

                        files.add(new ProjectFile(
                            key,
                            File.new_for_path(path)
                            ));
                    }
                    catch (Error error)
                    {
                        critical(error.message);
                    }
                }
            }
            catch (Error error)
            {
                critical(error.message);
            }

            return files.to_array();
        }


        /**
         * {@inheritDoc}
         */
        public override ProjectFile insert_file(File file)

            ensures(result != null)

        {
            ProjectFile item = null;

            try
            {
                var key = make_key();

                item = new ProjectFile(key, file);

                update_file(item);
            }
            catch (Error error)
            {
                critical(error.message);
            }

            return item;
        }


        /**
         * {@inheritDoc}
         */
        public override void remove_file(string key)

            requires(m_key_file != null)
            requires(m_key_file.has_group(SCHEMATIC_GROUP))

        {
            m_key_file.remove_key(
                SCHEMATIC_GROUP,
                key
                );
        }


        /**
         * {@inheritDoc}
         */
        public override void update_file(ProjectFile item)

            requires(item.key != null)
            requires(item.file != null)
            requires(folder != null)
            requires(m_key_file != null)

        {
            var file = item.file;
            var path = file.get_path();

            if (path != null)
            {
                if (file.has_prefix(folder))
                {
                    path = folder.get_relative_path(file) ?? path;
                }

                m_key_file.set_string(
                    SCHEMATIC_GROUP,
                    item.key,
                    path
                    );
            }
            else
            {
                m_key_file.set_string(
                    SCHEMATIC_GROUP,
                    item.key,
                    file.get_uri()
                    );
            }
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
         */
        private const string SCHEMATIC_PREFIX = "Schematic";


        /**
         * The group name in the key file that contains schematics
         */
        private const string SCHEMATIC_GROUP = "Schematics";


        /**
         * Checks if a key represents a schematic file
         */
        private static Regex s_schematic_key;


        /**
         *
         */
        private int m_current_number = 0;


        /**
         *
         */
        private File m_file;


        /**
         * The underlying key file used for persistence
         */
        private KeyFile m_key_file;


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
         * Make a unique key for a schematic
         *
         * The format of the key is a standard prefix, followed by a
         * period and then a number:
         *
         *     Schematic.01
         *
         * This function will find a numeric suffix to make the key
         * unique.
         *
         * @return a unique key to use in the key file
         */
        private string make_key() throws KeyFileError

            requires(m_key_file != null)

        {
            var current_name = "%s.%02d".printf(
                SCHEMATIC_PREFIX,
                ++m_current_number
                );

            if (m_key_file.has_group(SCHEMATIC_GROUP))
            {
                while (m_key_file.has_key(SCHEMATIC_GROUP, current_name))
                {
                    current_name = "%s.%02d".printf(
                        SCHEMATIC_PREFIX,
                        ++m_current_number
                        );
                }
            }

            return current_name;
        }
    }
}
