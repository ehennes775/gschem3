namespace Gschem3
{
    /**
     * Provides a user interface for the symbol library
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/LibraryWidget.ui.xml")]
    public class LibraryWidget : Gtk.Bin,
        ActionProvider,
        ComplexSelector,
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

            m_library_filter.buffer.notify["text"].connect(
                on_notify_filter
                );

            m_clear_filter_action.activate.connect(
                on_filter_clear
                );

            m_open_symbol_action.activate.connect(
                on_open_library_symbol
                );
        }


        /**
         * {@inheritDoc}
         */
        public void add_actions_to(ActionMap map)
        {
            map.add_action(m_clear_filter_action);
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
                m_slotter,
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
         * The name of the selected symbol
         */
        private string? b_name;


        /**
         * An adapter for the symbol library
         *
         * Adapts the SymbolLibrary to a Gtk.TreeModel
         */
        private LibraryAdapter m_adapter;


        /**
         * Clear the filter entry
         */
        private SimpleAction m_clear_filter_action = new SimpleAction(
            "library-filter-clear",
            null
            );


        /**
         * The model for the context menu
         */
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


        // temp located here for development
        private static Geda3.LibraryStore m_library;


        /**
         * The entry widget with the filter text
         */
        [GtkChild(name="library-filter")]
        private Gtk.Entry m_library_filter;


        /**
         * The column for the library item name
         */
        [GtkChild(name="column-name")]
        private Gtk.TreeViewColumn m_name_column;


        /**
         * Open a symbol from the library
         */
        private SimpleAction m_open_symbol_action = new SimpleAction(
            "open-library-symbol",
            null
            );


        /**
         * A pattern used to filter items in the tree
         */
        private PatternSpec? m_pattern = null;


        /**
         * The column for the library item name
         */
        [GtkChild(name="preview-widget")]
        private PreviewWidget m_preview_widget;


        // temp located here for development
        private static Geda3.AttributePromoter m_promoter =
            new Geda3.StandardPromoter();


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
         * The selection from the Gtk.TreeView widget
         */
        private Gtk.TreeSelection m_selection;


        /**
         *
         */
        private Geda3.Slotter m_slotter = new Geda3.DefaultSlotter();


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
        private bool on_button_release_event(Gdk.EventButton event)
        {
            if (event.triggers_context_menu())
            {
                var menu = new Gtk.Menu.from_model(m_context_menu);

                menu.attach_to_widget(m_tree_view, null);

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
         * Signal handler when the tree selection changes
         */
        private void on_changed_selection()
        {
            var items = get_selected_items();

            update_preview(items);
            update_sensitivities(items);
        }


        /**
         * Clear the filter entry
         *
         * @param parameter Unused
         */
        private void on_filter_clear(Variant? parameter)

            requires(m_library_filter != null)
            requires(m_library_filter.buffer != null)

        {
            m_library_filter.buffer.delete_text(0, -1);
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
            requires(m_library_filter.buffer != null)


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
         * Update the preview widget with the selected item
         *
         * @param items The selected items
         */
        private void update_preview(
            Gee.Collection<Geda3.LibraryItem> items
            )

            requires(items.all_match(i => i != null))
            requires(m_preview_widget != null)

        {
            var previewable_item = Geda3.GeeEx.single_match(
                items,
                is_openable
                );

            if (previewable_item != null)
            {
                var file_item = previewable_item as Geda3.LibraryFile;
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

            requires(items.all_match(i => i != null))
            requires(m_open_symbol_action != null)
            requires(m_remove_symbol_action != null)
            requires(m_rename_symbol_action != null)

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
