namespace Geda3
{
    /**
     * A base class for items in the project tree
     */
    public abstract class ProjectItem : Object
    {
        /**
         * An icon to display next to the short name
         */
        public abstract ProjectIcon icon
        {
            get;
            protected set;
        }


        /**
         * A short name to appear in widgets
         */
        public abstract string tab
        {
            get;
            protected set;
        }
    }
}
