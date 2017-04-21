namespace Geda3
{
    /**
     *
     */
    public abstract class ProjectStorage : Object
    {
        /**
         * Delete a schematic from the persistence store
         *
         * @param key The key for the schematic to delete from the
         * project
         */
        public abstract File folder
        {
            get;
            protected set;
        }


        /**
         * Delete a schematic from the persistence store
         *
         * @param key The key for the schematic to delete from the
         * project
         */
        public abstract ProjectItem[] get_files();


        /**
         * Delete a schematic from the persistence store
         *
         * @param key The key for the schematic to delete from the
         * project
         */
        public abstract ProjectItem insert_file(File file);


        /**
         * Save the project
         */
        public abstract void save();
    }
}
