namespace Gschem3
{
    /**
     * An interface for opening documents in the application
     */
    public interface DocumentOpener : Object
    {
        /**
         * Open an new document
         *
         * Specify document types as the file extension without the
         * dot.
         *
         * @param type Specifies the type of document to create
         */
        public abstract void open_new(string type);


        /**
         * Open an existing document
         *
         * @param file The document to open from a file
         */
        public abstract void open_with_file(File file);


        /**
         * Open existing documents
         *
         * @param files The documents to open from files
         */
        public abstract void open_with_files(File[] files);
    }
}
