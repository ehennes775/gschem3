namespace Geda3
{
    /**
     * Provides an interface for project storage
     *
     * This class provides an interface for implementing a persistence
     * layer for projects.
     */
    public abstract class ProjectStorage : Object
    {
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
         * Save the project
         *
         * Writes the values in memory to storage.
         */
        public abstract void save() throws Error;
    }
}
