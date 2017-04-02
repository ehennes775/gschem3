namespace Geda3
{
    /**
     *
     */
    public abstract class SchematicList
    {
        /**
         * Add a file to the list of schematics
         *
         * @param file The file to add to the list
         */
        public abstract bool add(File file);


        /**
         * Remove a file from the list of schematics
         *
         * @param file The file to remove from the list
         */
        public abstract bool remove(File file);
    }
}
