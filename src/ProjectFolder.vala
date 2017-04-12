namespace Geda3
{
    /**
     * A folder in the project tree
     */
    public class ProjectFolder : ProjectItem
    {
        /**
         * {@inheritDoc}
         */
        public override string tab
        {
            get;
            protected set;
        }


        /**
         * Initialize a new instance
         *
         * @param tab A name for this folder to show in the project
         * tree
         */
        public ProjectFolder(string? tab = null)
        {
            Object(
                tab : tab ?? "Unknown"
                );
        }
    }
}
