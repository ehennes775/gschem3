namespace Geda3
{
    /**
     * A base class for items in the project tree
     */
    public abstract class ProjectItem : Object
    {
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
