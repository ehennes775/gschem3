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
        public override File file
        {
            get;
            protected set;
        }


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
            this.file = file;

            m_key_file.load_from_file(
                this.file.get_path(),
                KeyFileFlags.KEEP_COMMENTS | KeyFileFlags.KEEP_TRANSLATIONS
                );

            folder = this.file.get_parent();
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

                        var absolute = Path.is_absolute(path);

                        if (!absolute)
                        {
                            path = Path.build_filename(
                                folder.get_path(),
                                path
                                );
                        }

                        files.add(new ProjectFile(
                            key,
                            File.new_for_path(path),
                            absolute
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

                item = new ProjectFile(key, file, false);

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
            try
            {
                m_key_file.remove_key(
                    SCHEMATIC_GROUP,
                    key
                    );
            }
            catch (Error error)
            {
                critical(error.message);
            }
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
                if (file.has_prefix(folder) || !item.absolute)
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

            requires(file != null)
            requires(m_key_file != null)

        {
            m_key_file.save_to_file(file.get_path());
        }


        /**
         * The string format for schematic keys
         *
         * The first format specifier is the SCHEMATIC_PREFIX. The
         * schematic prefix separates the schematic keys from other
         * keys in the same group.
         * 
         * The second format is the serial number. This is a
         * sequentially assigned unique number for the individual
         * schematic key.
         */
        private const string SCHEMATIC_KEY_FORMAT = "%s.%02d";


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
         * The underlying key file used for persistence
         */
        private KeyFile m_key_file;


        /**
         *
         *
         * @return A list of key names that contain schematic paths
         */
        private string[] get_schematic_keys() throws KeyFileError

            requires(m_key_file != null)
            requires(s_schematic_key != null)

        {
            var output_keys = new Gee.ArrayList<string>();

            if (m_key_file.has_group(SCHEMATIC_GROUP))
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
            var current_name = SCHEMATIC_KEY_FORMAT.printf(
                SCHEMATIC_PREFIX,
                ++m_current_number
                );

            if (m_key_file.has_group(SCHEMATIC_GROUP))
            {
                while (m_key_file.has_key(SCHEMATIC_GROUP, current_name))
                {
                    current_name = SCHEMATIC_KEY_FORMAT.printf(
                        SCHEMATIC_PREFIX,
                        ++m_current_number
                        );
                }
            }

            return current_name;
        }
    }
}
