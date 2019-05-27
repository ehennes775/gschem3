namespace Geda3
{
    /**
     * An interface for objects that contribute symbols to the library
     */
    public abstract interface LibraryContributor : Object
    {
        /**
         *
         */
        public abstract string contributor_name
        {
            get;
        }


        /**
         *
         */
        public abstract Gee.Collection<LibraryEntry> load_library_entries();
    }
}
