namespace Geda3
{
    /**
     * Wraps a library contributor for use in the library tree model
     */
    public class ContributorAdapter : LibraryItem
    {
        /**
         * The underlying contributor
         */
        public LibraryContributor contributor
        {
            get;
            private set;
        }


        /**
         * {@inheritDoc}
         */
        public override string? description
        {
            get;
            protected set;
        }


        /**
         * {@inheritDoc}
         */
        public override ProjectIcon icon
        {
            get;
            protected set;
        }


        /**
         * {@inheritDoc}
         */
        public override string tab
        {
            get;
            protected set;
        }


        /**
         * Initialize the instance
         *
         * @param contributor The contributor to wrap
         */
        public ContributorAdapter(LibraryContributor contributor)
        {
            Object(
                contributor : contributor,
                description : DESCRIPTION,
                icon : ProjectIcon.PLUM_FOLDER,
                tab : contributor.contributor_name
                );
        }


        /**
         * Uses an empty string for descriptoions to reduce clutter in
         * the UI.
         */
        private const string DESCRIPTION = "";
    }
}
