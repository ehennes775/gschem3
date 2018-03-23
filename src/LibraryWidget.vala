namespace Gschem3
{
    /**
     * Provides a user interface for the symbol library
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/LibraryWidget.ui.xml")]
    public class LibraryWidget : Gtk.Box
    {
        /**
         * The symbol library
         */
        public Geda3.SymbolLibrary? library
        {
            get
            {
                return m_adapter.library;
            }
            /*construct*/ set
            {
                m_adapter.library = value;
            }
        }


        /**
         * Initialize the instance
         */
        construct
        {
            m_adapter = new LibraryAdapter();

            // before model assignment until refresh signal handling
            library = new Geda3.SymbolLibrary();

            m_sort_model = new Gtk.TreeModelSort.with_model(m_adapter);
            m_tree_view.model = m_sort_model;

            m_description_column.clicked.connect(on_clicked_column);
            m_name_column.clicked.connect(on_clicked_column);
        }


        /**
         * The backing store for the symbol library
         */
        // private Geda3.SymbolLibrary? b_library;


        /**
         * An adapter for the symbol library
         *
         * Adapts the SymbolLibrary to a Gtk.TreeModel
         */
        private LibraryAdapter m_adapter;


        /**
         * The column for the library item description
         */
        [GtkChild(name="column-description")]
        private Gtk.TreeViewColumn m_description_column;


        /**
         * The column for the library item name
         */
        [GtkChild(name="column-name")]
        private Gtk.TreeViewColumn m_name_column;



        /**
         * Provides sorting functionality for library items
         */
        private Gtk.TreeSortable m_sort_model;


        /**
         * The TreeView containing the library items
         */
        [GtkChild(name="tree")]
        private Gtk.TreeView m_tree_view;


        /**
         * Adjusts sorting in response to tree column clicks
         *
         * Clicking on an tree column that is not sorted will make that
         * column the sorted column. Clicking on a tree column that is
         * sorted will toggle the sort ordering.
         *
         * If the current Gtk.TreeView model does not implement
         * Gtk.TreeSortable, then the column sort indicator and column
         * sort order must be updated manually. If the Gtk.TreeView
         * model implements TreeSortable, then the column sort indicator
         * and column sort order will update through signal handling.
         *
         * @param column The column that was clicked
         */
        private void on_clicked_column(Gtk.TreeViewColumn column)
        {
            var sort_order = column.sort_order;

            if (column.sort_indicator)
            {
                if (sort_order == Gtk.SortType.ASCENDING)
                {
                    sort_order = Gtk.SortType.DESCENDING;
                }
                else
                {
                    sort_order = Gtk.SortType.ASCENDING;
                }

                // Not needed if the Gtk.TreeView model implements
                // Gtk.TreeSortable. But, if the property values are
                // correct, then the property setters won't trigger
                // superfluous signals.

                column.sort_order = sort_order;
            }
            else
            {
                // Not needed if the Gtk.TreeView model implements
                // Gtk.TreeSortable. But, if the property values are
                // correct, then the property setters won't trigger
                // superfluous signals.

                m_description_column.sort_indicator = false;
                m_name_column.sort_indicator = false;

                column.sort_indicator = true;
            }

            m_sort_model.set_sort_column_id(
                column.sort_column_id,
                sort_order
                );
        }
    }
}
