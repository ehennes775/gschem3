namespace Geda3
{
    /**
     *
     */
    public class LibraryContributorTest : Object,
        LibraryContributor
    {
        /**
         *
         */
        public string contributor_name
        {
            get
            {
                return "Project Library";
            }
        }


        /**
         *
         */
        public Gee.Collection<LibraryEntry> load_library_entries()
        {
            return Gee.Collection<LibraryEntry>.empty();
        }
    }
}
