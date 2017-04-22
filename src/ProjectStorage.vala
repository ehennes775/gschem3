namespace Geda3
{
    /**
     *
     */
    public abstract class ProjectStorage : Object
    {
        /**
         * The project folder
         */
        public abstract File folder
        {
            get;
            protected set;
        }


        /**
         * Gets all the files in project storage
         *
         * @return an array of project items representing the project
         * files
         */
        public abstract ProjectFile[] get_files();


        /**
         * Inserts a new file into the projcet storage
         *
         * @param file the new file to add to the project storage
         * @return a project item representing the project file
         */
        public abstract ProjectFile insert_file(File file);


        /**
         * Updates the data in storages with the values of the item
         *
         * @param item The values to update storage
         */
        public abstract void update_file(ProjectFile item);


        /**
         * Save the project
         */
        public abstract void save();
    }
}
