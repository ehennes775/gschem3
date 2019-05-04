namespace Gschem3
{
    /**
     * Abstrat base class for tree views that edit attributes
     */
    public abstract class ColumnHelper : Object
    {
        /**
         * Update the data in the UI from the schematic
         */
        public abstract void update(Gtk.TreeIter iter);


        /**
         * The column containing the schematic item
         */
        protected int m_item_column;


        /**
         * The list store containing the pins
         */
        protected Gtk.ListStore m_store;
    }
}
