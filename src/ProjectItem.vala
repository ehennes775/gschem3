namespace Geda3
{
    /**
     * A base class for items in the project tree
     */
    public abstract class ProjectItem : Object
    {
        /**
         * Indicates the appearance of the item has changed
         */
        public signal void item_changed();


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


        /**
         * Initialize the instance
         */
        construct
        {
            notify["icon"].connect(on_notify);
            notify["tab"].connect(on_notify);
        }


        /**
         * Signal handler when a property changes
         *
         * This signal handler executes when a property that changes
         * the appearance of the item changes.
         */
        private void on_notify(ParamSpec param)
        {
            item_changed();
        }
    }
}
