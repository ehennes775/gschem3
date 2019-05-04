namespace Gschem3
{
    /**
     *
     */
    public abstract class ColumnHelper : Object
    {
        /**
         * Update the data in the UI from the schematic
         */
        public abstract void update(Gtk.TreeIter iter);
    }
}
