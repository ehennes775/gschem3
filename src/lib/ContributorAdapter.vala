namespace Geda3
{
    /**
     *
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
         *
         */
        public ContributorAdapter(LibraryContributor contributor)
        {
            this.contributor = contributor;

            description = "none";
            icon = ProjectIcon.PLUM_FOLDER;
            tab = contributor.contributor_name;
        }
    }
}
