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
        public abstract ProjectItem[] get_files();


        /**
         * Inserts a new file into the projcet storage
         *
         * @param file the new file to add to the project storage
         * @return a project item representing the project file
         */
        public abstract ProjectItem insert_file(File file);


        /**
         * Save the project
         */
        public abstract void save();
    }
}
