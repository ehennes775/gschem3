namespace Gschem3
{
    /**
     * Provides a user interface for the symbol library
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/LibraryWidget.ui.xml")]
    public class LibraryWidget : Gtk.Bin
    {
        /**
         * Requests files to be opened in an editor
         *
         * @param files The files to open in an editor
         */
        public signal void open_files(File[] files);


        /**
         * Indicates files can be opened from the project
         */
        public bool can_open_files
        {
            get;
            private set;

            // The default value establishes the initial value of the
            // "enabled" property on the action.
            default = false;
        }


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
            m_adapter.refresh.connect(on_refresh_adapter);

            m_filter_model = new Gtk.TreeModelFilter(m_adapter, null);
            m_filter_model.set_visible_func(is_row_visible);

            m_sort_model = new Gtk.TreeModelSort.with_model(m_filter_model);
            m_tree_view.model = m_sort_model;

            library = new Geda3.SymbolLibrary();

            // set up tree selection

            m_selection = m_tree_view.get_selection();
            m_selection.mode = Gtk.SelectionMode.MULTIPLE;
            m_selection.changed.connect(on_changed_selection);
        }


        /**
         * Gets the selected items from the library tree
         */
        private Gee.Collection<Geda3.LibraryItem> get_selected_items()

            requires(m_selection != null)

        {
            var items = new Gee.ArrayList<Geda3.LibraryItem>();

            m_selection.selected_foreach((model, path, iter) =>
                {
                    Geda3.LibraryItem? item = null;

                    model.get(
                        iter,
                        LibraryAdapter.Column.ITEM, &item
                        );

                    if (item is Geda3.LibraryItem)
                    {
                        items.add(item);
                    }
                    else
                    {
                        warning("LibraryAdapter contans invalid item");
                    }
                }
                );

            return items;
        }


        /**
         * Determines if the item is openable
         *
         * @param item The item to check if it can be opened
         * @return This function returns true when the item is openable
         */
        private bool is_openable(Geda3.LibraryItem item)
        {
            var file_item = item as Geda3.LibraryFile;

            return (
                (file_item != null) &&
                (file_item.file != null) &&
                file_item.can_open
                );
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
         * Provides sorting functionality for library items
         */
        private Gtk.TreeModelFilter m_filter_model;


        /**
         * The column for the library item name
         */
        [GtkChild(name="column-name")]
        private Gtk.TreeViewColumn m_name_column;


        /**
         * A pattern used to filter items in the tree
         */
        private PatternSpec? m_pattern = null;


        /**
         * The column for the library item name
         */
        [GtkChild(name="preview-widget")]
        private PreviewWidget m_preview_widget;


        /**
         * Provides sorting functionality for library items
         */
        private Gtk.TreeSortable m_sort_model;


        /**
         * The selection from the Gtk.TreeView widget
         */
        private Gtk.TreeSelection m_selection;


        /**
         * The TreeView containing the library items
         */
        [GtkChild(name="tree")]
        private Gtk.TreeView m_tree_view;


        /**
         * Check if a row is visible in the filter model
         *
         * @param model The tree model
         * @param iter the iterator to test for visibility.
         * @return If the row is visible, this returns true.
         */
        private bool is_row_visible(Gtk.TreeModel model, Gtk.TreeIter iter)
        {
            var visible = (m_pattern == null);

            if (!visible && model.iter_has_child(iter))
            {
                Gtk.TreeIter child_iter;
                var success = model.iter_children(out child_iter, iter);

                while (success)
                {
                    visible = is_row_visible(model, child_iter);

                    if (visible)
                    {
                        break;
                    }

                    success = model.iter_next(ref child_iter);
                } 
            }

            if (!visible)
            {
                Geda3.LibraryItem? item = null;

                model.get(
                    iter,
                    LibraryAdapter.Column.ITEM, &item
                    );

                return_val_if_fail(item != null, visible);

                var tab = item.tab;

                visible = m_pattern.match_string(tab);

                if (!visible)
                {
                    var description = item.description;

                    if (description != null)
                    {
                        visible = m_pattern.match_string(description);
                    }
                }
            }

            return visible;
        }


        /**
         *
         *
         */
        private void on_changed_selection()
        {
            var items = get_selected_items();

            update_preview(items);
            update_sensitivities(items);
        }


        /**
         * Adjusts sorting in response to tree column clicks
         *
         * If the Gtk.TreeView model property implements
         * Gtk.TreeSortable, then this functionality is built-in. Not
         * sure what happens if an adapter is in between, so this code
         * is kept around.
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


        /**
         * Signal handler for when the tree view needs a complete
         * refresh
         */
        private void on_refresh_adapter()
        {
            m_tree_view.model = null;
            m_tree_view.model = m_sort_model;
        }


        /**
         *
         *
         * @param items The selected items
         */
        private void update_preview(Gee.Collection<Geda3.LibraryItem> items)

            requires(items != null)
            requires(m_preview_widget != null)

        {
            var previewable = Geda3.GeeEx.one_match(
                items,
                is_openable
                );

            if (previewable)
            {
                // available in Gee 19.91
                // var item = items.first_match(is_openable);

                Geda3.LibraryItem? item = null;

                foreach (var iter in items)
                {
                    if (is_openable(iter))
                    {
                        item = iter;
                        break;
                    }
                }

                return_if_fail(item != null);

                var file_item = item as Geda3.LibraryFile;
                return_if_fail(file_item != null);

                m_preview_widget.load(file_item.file);
            }
            else
            {
                m_preview_widget.load(null);
            }
        }


        /**
         * Update senstitivities for actions in this widget
         *
         * @param items The selected items
         */
        private void update_sensitivities(Gee.Collection<Geda3.LibraryItem> items)

            requires(items != null)

        {
            can_open_files = Geda3.GeeEx.any_match(
                items,
                is_openable
                );

            //can_remove_files = Geda3.GeeEx.any_match(
            //    items,
            //    is_removable
            //    );

            //can_rename_item = Geda3.GeeEx.one_match(
            //    items,
            //    Geda3.ProjectItem.is_renamable
            //    );
        }
    }
}
