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
         * @param name The name of the folder shown in the project tree
         */
        public ProjectFolder(string name)
        {
            tab = name;
        }
    }
}
