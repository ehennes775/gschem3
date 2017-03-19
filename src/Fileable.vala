namespace Gschem3
{
    /**
     * An interface for document windows that can contain an underlying
     * file
     */
    public interface Fileable : Object
    {
        /**
         * A string uniquly identifing the file
         *
         * If this value is null, an underlying file has not been
         * created yet.
         */
        public abstract string? file_id
        {
            get;
            protected set;
        }

        /**
         * The underlying file for this document
         *
         * If this value is null, an underlying file has not been
         * created yet.
         */
        public abstract File? file
        {
            get;
            protected set;
        }
    }
}
