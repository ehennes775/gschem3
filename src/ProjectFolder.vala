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
         * Initialize a new instance
         *
         * @param tab A name for this folder to show in the project
         * tree
         */
        public ProjectFolder(ProjectIcon icon = ProjectIcon.MISSING, string? tab = null)
        {
            Object(
                icon : icon,
                tab : tab ?? "Unknown"
                );
        }


        /**
         * {@inheritDoc}
         */
        public override void remove(ProjectStorage storage)
        {
        }
    }
}
