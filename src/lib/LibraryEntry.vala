namespace Geda3
{
    /**
     * Represents a library entry from read from a key file
     */
    public class LibraryEntry
    {
        /**
         * A description of the library for the user
         */
        public string description
        {
            get;
            private set;
        }


        /**
         * The folder the symbols reside in
         */
        public File folder
        {
            get;
            private set;
        }


        /**
         * A unique ID for this library, withing the same key file
         *
         * Duplicate IDs may occur across key files.
         */
        public string id
        {
            get;
            private set;
        }


        /**
         * A short name, for the library, for the user
         */
        public string name
        {
            get;
            private set;
        }


        /**
         * Read the library entries from a key file
         *
         * @param key_file The key file to read the entries from
         */
        public static Gee.Collection<LibraryEntry> read(
            KeyFile key_file
            )
            throws KeyFileError
        {
            var entries = new Gee.ArrayList<LibraryEntry>();

            foreach (var group_name in key_file.get_groups())
            {
                if (group_name.has_suffix(LIBRARY_SUFFIX))
                {
                    var entry = create(
                        key_file,
                        group_name
                        );

                    entries.add(entry);
                }
            }

            return entries;
        }


        /**
         * The description to use when not specified in the key file
         */
        private const string DEFAULT_DESCRIPTION = "";


        /**
         * The name of the key containing the description
         */
        private const string DESCRIPTION_KEY = "description";


        /**
         * The name of the key contining the folder
         *
         * The path specified may be absolute or relative.
         */
        private const string FOLDER_KEY = "folder";


        /**
         * The suffix on group names for library entries
         */
        private const string LIBRARY_SUFFIX = ".library";


        /**
         * The name of the key containing the library name
         */
        private const string NAME_KEY = "name";


        /**
         * The name of the key containing the library name
         *
         * @param key_file The key file to read the string from
         * @param group_name The name of the group withing the key file
         * @throws KeyFileError.KEY_NOT_FOUND
         */
        private static LibraryEntry create(
            KeyFile key_file,
            string group_name
            )
            throws KeyFileError
        {
            var description = extract_optional_string(
                key_file,
                group_name,
                DESCRIPTION_KEY,
                DEFAULT_DESCRIPTION
                );

            var folder = extract_folder(
                key_file,
                group_name,
                FOLDER_KEY
                );

            var name = extract_optional_string(
                key_file,
                group_name,
                NAME_KEY,
                folder.get_basename()
                );

            var entry = new LibraryEntry()
            {
                id = group_name,
                name = name,
                folder = folder,
                description = description
            };

            return entry;
        }


        /**
         * Get the required folder entry from the key file
         *
         * @param key_file The key file to read the string from
         * @param group_name The name of the group withing the key file
         * @param key_name The name of the key within the group
         * @return The folder, converted to a path
         * @throws KeyFileError.KEY_NOT_FOUND
         */
        private static File extract_folder(
            KeyFile key_file,
            string group_name,
            string key_name
            )
            throws KeyFileError
        {
            var path = key_file.get_string(
                group_name,
                key_name
                );

            var file = File.new_for_path(path);

            return file;
        }


        /**
         * Get an optional string value from the key file
         *
         * @param key_file The key file to read the string from
         * @param group_name The name of the group withing the key file
         * @param key_name The name of the key within the group
         * @param default_value The value to use when not present
         * @return The string extracted from the key file
         */
        private static string extract_optional_string(
            KeyFile key_file,
            string group_name,
            string key_name,
            string default_value
            )
        {
            try
            {
                var @value = key_file.get_string(
                    group_name,
                    key_name
                    );

                return @value;
            }
            catch (Error error)
            {
                return default_value;
            }
        }
    }
}
