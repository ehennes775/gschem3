namespace Gschem3
{
    /**
     *
     */
    public abstract class DocumentWindowFactory : Object
    {
        /**
         * Create a new document window
         */
        public abstract DocumentWindow create();


        /**
         * Create a new window from a file
         *
         * @param file The file to edit in the schematic window
         */
        public abstract DocumentWindow create_with_file(File file);
    }
}
