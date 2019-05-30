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
         * @param type Specifies the type of document to create
         */
        public abstract void open_new(string type);


        /**
         * Open an existing document
         *
         * @param file The document to open as a file
         */
        public abstract void open_with_file(File file);
    }
}
