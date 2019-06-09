namespace Geda3
{
    /**
     * Provides a persistence layer for storing projects
     *
     * This class uses the Repository pattern from Martin Fowler's
     * book, with exceptions. Instead of using functions for updating
     * and removing objects, derived classes connect to signals on
     * objects that originate from their repository.
     *
     * [[https://www.martinfowler.com/eaaCatalog/repository.html]]
     */
    public abstract class ProjectStorage : Object
    {
        /**
         * Indicates an item has been removed from storage
         */
        public signal void item_removed(ProjectItem item);


        /**
         * Indicates the project has changed since last saved
         */
        public abstract bool changed
        {
            get;
            protected set;
        }


        /**
         * The project file
         *
         * No relationship between the project file and project folder
         * should be assumed by clients of this class.
         */
        public abstract File file
        {
            get;
            protected set;
        }


        /**
         * The project folder
         *
         * No relationship between the project file and project folder
         * should be assumed by clients of this class.
         */
        public abstract File folder
        {
            get;
            protected set;
        }


        /**
         * Gets all the files in the project
         *
         * @return an array of project items representing the project
         * files
         */
        public abstract ProjectFile[] get_files();


        /**
         * Inserts a new file into the project
         *
         * Inserts a new item into the project to represent the given
         * file. This function updates the project in memory and does
         * not write the project to storage. The save function must be
         * called to write the values to storage.
         *
         * Currently, the file should not be a duplicate reference to a
         * file already in the project.
         *
         * @param file the new file to add to the project storage
         * @return a project item representing the project file
         */
        public abstract ProjectFile insert_file(File file);


        /**
         * Load the libraries from the project file
         *
         * @return The library entries from the project file
         */
        public abstract Gee.Collection<LibraryEntry> load_library_entries();


        /**
         * Get the netlist export format from the configuration
         *
         * Pass the default value into this function. If the
         * configuration item exists, this function replaces the
         * argument with the value. If the configuration item does
         * not exist, the argument remains unchanged.
         *
         * @param format The netlist export format
         */
        public abstract void retrieve_netlist_export_format(
            ref string format
            );


        /**
         * Get the partlist export format from the configuration
         *
         * Pass the default value into this function. If the
         * configuration item exists, this function replaces the
         * argument with the value. If the configuration item does
         * not exist, the argument remains unchanged.
         *
         * @param format The partlist export format
         */
        public abstract void retrieve_partlist_export_format(
            ref string format
            );


        /**
         * Save the project
         *
         * Writes the values in memory to storage.
         */
        public abstract void save() throws Error;


        /**
         * Set the netlist export format in the configuration
         *
         * @param format The netlist export format
         */
        public abstract void store_netlist_export_format(
            string format
            );


        /**
         * Set the partlist export format in the configuration
         *
         * @param format The partlist export format
         */
        public abstract void store_partlist_export_format(
            string format
            );
    }
}
