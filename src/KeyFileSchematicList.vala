namespace Geda3
{
    /**
     *
     */
    public class KeyFileSchematicList : SchematicList
    {
        /**
         * Create a new schematic list based off a key file
         */
        public KeyFileSchematicList(KeyFile key_file)
        {
            m_key_file = key_file;
        }


        /**
         * {@inheritDoc}
         */
        public override bool add(File file)

            requires(m_key_file != null)
            requires(m_schematic_files != null)

        {
            var schematic_file = find_by_file(file);
            var success = false;

            if (schematic_file == null)
            {
                var key = make_key();

                schematic_file = new SchematicFile(file);

                success = m_schematic_files.add(schematic_file);

                if (success)
                {
                    m_key_file.set_string(
                        GROUP_NAME,
                        key,
                        file.get_uri()
                        );
                }
            }

            return success;
        }


        /**
         * {@inheritDoc}
         */
        public override bool remove(File file)

            requires(m_key_file != null)
            requires(m_schematic_files != null)

        {
            var schematic_file = find_by_file(file);
            var success = true;

            if (schematic_file != null)
            {
                success = m_schematic_files.remove(schematic_file);

                if (success)
                {
                    m_key_file.remove_key(
                        GROUP_NAME,
                        schematic_file.key
                        );
                }
            }

            return success;
        }


        /**
         *
         */
        private const string GROUP_NAME = "SymbolLibraries";


        /**
         *
         */
        private const string KEY_PREFIX = "Schematic";


        /**
         *
         */
        private int m_current_number = 0;


        /**
         *
         */
        private KeyFile m_key_file;


        /**
         *
         */
        private Gee.ArrayList<SchematicFile> m_schematic_files;


        /**
         * Find a schematic in the list using the file
         *
         * @param file the file for the schematic
         * @return The SchematicFile or null if not found
         */
        private SchematicFile? find_by_file(File file)

            requires(m_schematic_files != null)

        {
            var file_info = file.query_info(
                FileAttribute.ID_FILE,
                FileQueryInfoFlags.NONE
                );

            var file_id = file_info.get_attribute_string(
                FileAttribute.ID_FILE
                );

            if (file_id == null)
            {
                return null;
            }

            foreach (var schematic_file in m_schematic_files)
            {
                if (file_id == schematic_file.id)
                {
                    return schematic_file;
                }
            }

            return null;
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
        private string make_key()

            requires(m_key_file != null)

        {
            var current_name = "%s.%02d".printf(
                KEY_PREFIX,
                ++m_current_number
                );

            try
            {
                while (m_key_file.has_key(GROUP_NAME, current_name))
                {
                    current_name = "%s.%02d".printf(
                        KEY_PREFIX,
                        ++m_current_number
                        );
                }
            }
            catch (KeyFileError error)
            {
                if (!(error is KeyFileError.GROUP_NOT_FOUND))
                {
                    throw error;
                }
            }

            return current_name;
        }
    }
}
