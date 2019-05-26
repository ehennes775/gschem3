namespace Geda3
{
    /**
     * A schematic symbol libraries based off of a key file
     */
    public class KeyFileSymbolLibrary : OldSymbolLibrary
    {
        /**
         * Create a new symbol library based off a key file
         */
        public KeyFileSymbolLibrary(KeyFile key_file)
        {
            m_key_file = key_file;
        }


        /**
         * {@inheritDoc}
         */
        public override bool add(File file)
        {
            var folder = find_by_file(file);
            var success = false;

            if (folder == null)
            {
                var key = make_key(file);

                folder = new KeyFileSymbolFolder(file);

                success = m_folders.add(folder);

                if (success)
                {
                    m_key_file.set_string(GROUP_NAME, key, file.get_uri());
                }
            }

            return success;
        }


        /**
         * An abstract base class for schematic symbol libraries
         */
        private const string GROUP_NAME = "SymbolLibraries";


        /**
         * An abstract base class for schematic symbol libraries
         */
        private Gee.ArrayList<KeyFileSymbolFolder> m_folders;


        /**
         * An abstract base class for schematic symbol libraries
         */
        private KeyFile m_key_file;


        /**
         * Find a folder in the library using the file
         *
         * @param file the directory of the symbol folder
         * @return The KeyFileSymbolFolder with the same file
         */
        private KeyFileSymbolFolder? find_by_file(File file)

            requires(m_folders != null)

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

            foreach (var folder in m_folders)
            {
                if (file_id == folder.id)
                {
                    return folder;
                }
            }

            return null;
        }


        /**
         * Make a unique key for the symbol folder
         *
         * @param file the directory of the symbol folder
         * @return a unique key to use in the key file
         */
        private string make_key(File file)

            requires(m_key_file != null)

        {
            var basename = file.get_basename();

            try
            {
                var current_name = basename;
                var current_number = 0;

                while (m_key_file.has_key(GROUP_NAME, current_name))
                {
                    current_name = @"$(basename)_$(++current_number)";
                }

                return current_name;
            }
            catch (KeyFileError error)
            {
                if (error is KeyFileError.GROUP_NOT_FOUND)
                {
                    
                }
            }

            return basename;
        }
    }
}
