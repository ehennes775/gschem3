namespace Gschem3
{
    /**
     * Provides a user interface for the symbol library
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/LibraryWidget.ui.xml")]
    public class LibraryWidget :
        ActionProvider,
        ComplexSelector,
        Gtk.Bin,
        Gtk.Buildable
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
         * For opening files in the application
         */
        public DocumentOpener opener
        {
            get;
            set;
        }


        /**
         * The name of the selected symbol
         */
        public string? symbol_name
        {
            get
            {
                return b_name;
            }
            construct set
            {
                b_name = value;

                recreate_symbol();
                symbol_changed();
            }
            default = null;
        }


        static construct
        {
            stdout.printf("%s\n",typeof(Geda3.SchematicReader).name());
            m_library = Geda3.LibraryStore.get_instance();
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

            //library = new Geda3.OldSymbolLibrary();
            library = m_library;

            // set up tree selection

            m_selection = m_tree_view.get_selection();
            m_selection.mode = Gtk.SelectionMode.MULTIPLE;
            m_selection.changed.connect(on_changed_selection);

            // Setup context menu

            m_tree_view.events |= Gdk.EventMask.BUTTON_PRESS_MASK;
            m_tree_view.button_press_event.connect(on_button_release_event);

            //

            m_library_filter.buffer.notify["text"].connect(on_notify_filter);



            m_open_symbol_action.activate.connect(
                on_open_library_symbol
                );
        }


        /**
         * {@inheritDoc}
         */
        public void parser_finished(Gtk.Builder builder)

            ensures(m_context_menu != null)

        {
            var builder2 = new Gtk.Builder.from_resource(
                "/com/github/ehennes775/gschem3/gui/LibraryWidgetMenu.ui.xml"
                );

            m_context_menu = builder2.get_object("context") as MenuModel;
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


        // temp located here for development
        private static Geda3.LibraryStore m_library;


        // temp located here for development
        private static Geda3.AttributePromoter m_promoter = new Geda3.StandardPromoter();


        /**
         * {@inheritDoc}
         */
        public void add_actions_to(ActionMap map)
        {
            map.add_action(m_open_symbol_action);
            map.add_action(m_remove_symbol_action);
            map.add_action(m_rename_symbol_action);
        }


        /**
         * {@inheritDoc}
         */
        public Geda3.ComplexItem? create_symbol()
        {
            var complex = new Geda3.ComplexItem.with_name(
                m_library,
                symbol_name
                );

            var promoted = m_promoter.promote(complex.symbol.schematic.items);

            foreach (var attribute in promoted)
            {
                complex.attach(attribute);
            }

            return complex;
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
         * Determines if the item is removable
         *
         * @param item The item to check if it can be removed
         * @return This function returns true when the item is removable
         */
        private bool is_removable(Geda3.LibraryItem item)
        {
            var removable_item = item as Geda3.RemovableItem;

            return (
                (removable_item != null) &&
                removable_item.can_remove
                );
        }


        /**
         * Determines if an item is renamable
         *
         * @param item The item to check if it can be renamed
         * @return This function returns true when the item is renamable
         */
        public bool is_renamable(Geda3.LibraryItem item)
        {
            var renamable_item = item as Geda3.RenamableItem;

            return (
                (renamable_item != null) &&
                renamable_item.can_rename
                );
        }


        /**
         * Open a symbol from the library
         */
        private SimpleAction m_open_symbol_action = new SimpleAction(
            "open-library-symbol",
            null
            );


        /**
         * Removes a symbol from the library
         *
         * (This Should probably renamed to delete.)
         */
        private SimpleAction m_remove_symbol_action = new SimpleAction(
            "remove-library-symbol",
            null
            );


        /**
         * Renames a symbol in the library
         */
        private SimpleAction m_rename_symbol_action = new SimpleAction(
            "rename-library-symbol",
            null
            );


        /**
         * The backing store for the symbol library
         */
        // private Geda3.SymbolLibrary? b_library;


        private string? b_name;


        /**
         * An adapter for the symbol library
         *
         * Adapts the SymbolLibrary to a Gtk.TreeModel
         */
        private LibraryAdapter m_adapter;


        private MenuModel m_context_menu;


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
         * The selection from the Gtk.TreeView widget
         */
        private Gtk.TreeSelection m_selection;


        /**
         * Provides sorting functionality for library items
         */
        private Gtk.TreeSortable m_sort_model;


        /**
         * The TreeView containing the library items
         */
        [GtkChild(name="tree")]
        private Gtk.TreeView m_tree_view;


        [GtkChild(name="library-filter")]
        private Gtk.Entry m_library_filter;


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
         * Signal handler when the tree selection changes
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
         *
         * @todo This function is not displaying a popup menu.
         */
        private bool on_button_release_event(Gdk.EventButton event)
        {
            if (event.triggers_context_menu())
            {
                var menu = new Gtk.Menu.from_model(m_context_menu);

                //menu.show_all();

                // Depricated GTK+ 3.22
                menu.popup(
                    null,
                    null,
                    null,
                    event.button,
                    event.time
                    );

                //menu.popup_at_pointer(null);

                return true;
            }

            return false;
        }


        /**
         * Signal handler for opening library symbols
         *
         * The user requests to open the library symbols selected in
         * the tree view.
         *
         * @param parameter Unused
         */
        private void on_open_library_symbol(Variant? parameter) 
        {
            var files = new Gee.ArrayList<File>();
            var items = get_selected_items();

            foreach (var item in items)
            {
                if (!is_openable(item))
                {
                    continue;
                }

                var file_item = item as Geda3.LibraryFile;
                return_if_fail(file_item != null);

                files.add(file_item.file);
            }

            opener.open_with_files(files.to_array());
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
         * Signal handler for changes to the filter text
         *
         * @param param unused
         */
        private void on_notify_filter(ParamSpec param)

            requires(m_filter_model != null)
            requires(m_library_filter != null)

        {
            var text = m_library_filter.buffer.text;

            if ((text != null) && (text.length > 0))
            {
                m_pattern = new PatternSpec(@"*$(text)*");
            }
            else
            {
                m_pattern = null;
            }

            m_filter_model.refilter();
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

                // temporary for development
                symbol_name = file_item.file.get_basename();
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
        private void update_sensitivities(
            Gee.Collection<Geda3.LibraryItem> items
            )

            requires(items != null)
            requires(items.all_match(i => i != null))

        {
            m_open_symbol_action.set_enabled(
                items.any_match(
                    is_openable
                    ));

            m_remove_symbol_action.set_enabled(
                items.any_match(
                    is_removable
                    ));

            m_rename_symbol_action.set_enabled(
                Geda3.GeeEx.one_match(
                    items,
                    is_renamable
                    ));
        }
    }
}
