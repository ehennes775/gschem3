namespace Gschem3
{
    /**
     *
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/aedit/AttributeEditor.ui.xml")]
    public class AttributeEditor : Gtk.Box,
        Gtk.Buildable
    {
        /**
         *
         */
        public DocumentSelector selector
        {
            get
            {
                return null;
            }
            set
            {
                stdout.printf("Setting to main window\n");
            }
        }


        /**
         * The current item being edited
         *
         * When null, no item, representing an attribute, is currently
         * being edited.
         */
        public Geda3.SchematicItem? item
        {
            get
            {
                return b_item;
            }
            private construct set
            {
                if (b_item != null)
                {
                    b_item.attached.disconnect(on_attribute_attached);
                    b_item.detached.disconnect(on_attribute_detached);
                }

                b_item = value as Geda3.AttributeParent;

                if (b_item != null)
                {
                    b_item.attached.connect(on_attribute_attached);
                    b_item.detached.connect(on_attribute_detached);
                }

                update_attribute_list();
                update_insert_sensitivity();
            }
            default = null;
        }


        /**
         * The text to show when an attribute is missing the name or
         * value
         */
        public string missing_text
        {
            get;
            construct set;
            default = "missing";
        }


        /**
         * The schematic window containing the current selection
         *
         * If null, there is no current window, or the current window
         * is not editing a schmeatic.
         */
        public SchematicWindow? schematic_window
        {
            get
            {
                return b_schematic_window;
            }
            construct set
            {
                if (b_schematic_window != null)
                {
                    b_schematic_window.attribute_changed.disconnect(
                        on_attribute_changed
                        );

                    b_schematic_window.selection_changed.disconnect(
                        on_selection_changed
                        );
                }

                b_schematic_window = value;

                if (b_schematic_window != null)
                {
                    b_schematic_window.attribute_changed.connect(
                        on_attribute_changed
                        );

                    b_schematic_window.selection_changed.connect(
                        on_selection_changed
                        );
                }

                update_selected_item();
            }
            default = null;
        }


        /**
         * Initialize the instance
         */
        construct
        {
            m_name_renderer.edited.connect(on_item_name_edited);
            m_value_renderer.edited.connect(on_item_value_edited);
            m_visible_renderer.toggled.connect(on_item_visible_toggled);

            m_show_name_renderer.toggled.connect(on_item_show_name_toggled);
            m_show_name_value_renderer.toggled.connect(on_item_show_name_value_toggled);
            m_show_value_renderer.toggled.connect(on_item_show_value_toggled);

            m_selection = m_view.get_selection();

            m_selection.mode = Gtk.SelectionMode.MULTIPLE;
            m_selection.changed.connect(on_view_selection_changed);

            m_detach_button.sensitive = false;
            m_detach_button.clicked.connect(on_detach_button_clicked);

            m_remove_button.sensitive = false;
            m_remove_button.clicked.connect(on_remove_button_clicked);

            m_insert_button.sensitive = false;
            m_insert_button.clicked.connect(on_insert_button_clicked);
        }


        /**
         * {@inheritDoc}
         */
        public void update_document_window(DocumentWindow? window)
        {
            schematic_window = window as SchematicWindow;
        }


        /**
         * Delegate used to update the state of an attribute
         *
         * @param state The state to update with new values
         */
        private delegate void AttributeStateUpdater(
            AttributeState state
            );


        /**
         * The columns in the list store
         *
         * This enumeration must be kept in sync with the UI XML.
         */
        private enum Column
        {
            STATE,
            NAME,
            NAME_EDITABLE,
            VALUE,
            VALUE_EDITABLE,
            VISIBLE,
            VISIBLE_EDITABLE,
            SHOW_NAME,
            SHOW_NAME_EDITABLE,
            SHOW_VALUE,
            SHOW_VALUE_EDITABLE,
            SHOW_NAME_VALUE,
            SHOW_NAME_VALUE_EDITABLE
        }


        /**
         * The backing store for the current item being edited
         */
        private Geda3.AttributeParent? b_item;


        /**
         * The backing store for the schematic window
         */
        private SchematicWindow? b_schematic_window;


        /**
         * The button to detach one or more attributes
         */
        [GtkChild(name="detach-button")]
        private Gtk.Button m_detach_button;


        /**
         * The button to insert an attribute
         */
        [GtkChild(name="insert-button")]
        private Gtk.Button m_insert_button;


        /**
         * The list store of the attributes
         */
        [GtkChild(name="list")]
        private Gtk.ListStore m_list;


        /**
         * The renderer for the attribute name
         */
        [GtkChild(name="column-name-renderer-name")]
        private Gtk.CellRendererText m_name_renderer;



        /**
         * The button to remove one or more attributes
         */
        [GtkChild(name="remove-button")]
        private Gtk.Button m_remove_button;


        /**
         *
         */
        private Geda3.AttributePositioner m_positioner =
            new Geda3.BasicAttributePositioner();


        /**
         * The tree view selection containing the attributes
         */
        private Gtk.TreeSelection m_selection;


        /**
         * The renderer for the attribute name presentation
         */
        [GtkChild(name="column-presentation-renderer-name")]
        private Gtk.CellRendererToggle m_show_name_renderer;


        /**
         * The renderer for the attribute name and value presentation
         */
        [GtkChild(name="column-presentation-renderer-name-value")]
        private Gtk.CellRendererToggle m_show_name_value_renderer;


        /**
         * The renderer for the attribute value presentation
         */
        [GtkChild(name="column-presentation-renderer-value")]
        private Gtk.CellRendererToggle m_show_value_renderer;


        /**
         * The tree view containing the attributes
         */
        [GtkChild(name="tree")]
        private Gtk.TreeView m_view;


        /**
         * The renderer for the attribute value
         */
        [GtkChild(name="column-value-renderer-value")]
        private Gtk.CellRendererText m_value_renderer;


        /**
         * The renderer for the attribute visibility
         */
        [GtkChild(name="column-visible-renderer-visible")]
        private Gtk.CellRendererToggle m_visible_renderer;


        /**
         * Clear the list of attributes
         */
        private void clear_attribute_list()

            requires(m_list != null)

        {
            Gtk.TreeIter iter;

            var success = m_list.get_iter_first(out iter);

            while (success)
            {
                // disconnect

                success = m_list.iter_next(ref iter);
            }

            m_list.clear();
        }


        /**
         *
         */
        private void change_attribute_state(
            string path_string,
            AttributeStateUpdater update
            )
        {
            var path = new Gtk.TreePath.from_string(path_string);

            var state = get_attribute_state_path(path);
            return_if_fail(state != null);

            update(state);

            if (state.request_removal)
            {
                create_and_attach(
                    path_string,
                    state as AttributeCreating
                    );
            }
            else
            {
                update_row_path(path);
            }
        }


        /**
         *
         */
        private void create_and_attach(
            string path_string,
            AttributeCreating current_state
            )

            requires(m_list != null)
            
        {
            // block

            var new_attribute = current_state.create_and_attach(
                m_positioner
                );

            // unblock
            
            var path = new Gtk.TreePath.from_string(path_string);

            Gtk.TreeIter iter;
            var success = m_list.get_iter(out iter, path);
            return_val_if_fail(success, null);

            var next_state = new AttributeEditing(new_attribute);

            m_list.@set(iter, Column.STATE, next_state);

            update_row_iter(iter);
        }


        /**
         * Get the attribute state from the model using an iterator
         *
         * @param iter The iterator of the node in the model
         * @return The attribute state
         */
        private AttributeState get_attribute_state_iter(
            Gtk.TreeIter iter
            )

            requires(m_list != null)
            requires(m_list.iter_is_valid(iter))

        {
            Value @value;

            m_list.get_value(iter, Column.STATE, out @value);

            return @value.get_object() as AttributeState;
        }


        /**
         * Get the attribute state from the model using a path
         *
         * @param path The path to the node in the model
         * @return The attribute state
         */
        private AttributeState get_attribute_state_path(
            Gtk.TreePath path
            )

            requires(m_list != null)

        {
            Gtk.TreeIter iter;

            var success = m_list.get_iter(out iter, path);
            return_val_if_fail(success, null);

            return get_attribute_state_iter(iter);
        }


        /**
         * Signal hander when a new attribute is attached
         *
         * @param child The attribute that changed
         * @param parent The attribute parent object
         */
        private void on_attribute_attached(
            Geda3.AttributeChild child,
            Geda3.AttributeParent parent
            )
        {
            update_attribute_list();
        }


        /**
         * Signal handler with an attribute name or value is changed
         *
         * @param child The attribute that changed
         * @param parent The attribute parent object
         */
        private void on_attribute_changed(
            Geda3.AttributeChild child,
            Geda3.AttributeParent parent
            )
        {
            update_attribute_list();
        }


        /**
         * Signal handler for when an attribute is detached
         *
         * @param child The attribute that changed
         * @param parent The attribute parent object
         */
        private void on_attribute_detached(
            Geda3.AttributeChild child,
            Geda3.AttributeParent parent
            )
        {
            update_attribute_list();
        }


        /**
         *
         */
        private void on_detach_button_clicked()

            requires(b_item != null)
            requires(m_selection != null)

        {
            var attributes = new Gee.HashSet<Geda3.AttributeChild>();

            //Gtk.TreeModel dummy;
            //var paths = m_selection.get_selected_rows(out dummy);

            //foreach (var path in paths)
            //{
            //    var attribute = get_attribute_path(path);

            //    attributes.add(attribute);
            //}

            foreach (var attribute in attributes)
            {
                b_item.detach(attribute);
            }
        }


        /**
         *
         */
        private void on_insert_button_clicked()

            requires(m_list != null)

        {
            var creator = b_item as Geda3.AttributeCreator;
            return_if_fail(creator != null);
            
            Gtk.TreeIter iter;

            m_list.append(out iter);

            var state = new AttributeCreating(creator);

            m_list.@set(iter, Column.STATE, state);

            update_row_iter(iter);
        }


        /**
         * Signal handler when the list of selected items changes
         */
        private void on_selection_changed()
        {
            update_selected_item();
        }


        /**
         * Make updates to the attribute name after editing
         *
         * @param renderer Unused
         * @param path_string The tree path in string represenation
         * @param new_name The new attribute name
         */
        private void on_item_name_edited(
            Gtk.CellRendererText renderer,
            string path_string,
            string new_name
            )
        {
            change_attribute_state(
                path_string,
                (state) => { state.name = new_name; }
                );
        }


        /**
         * Set the presentation to show the name of the attribute
         *
         * @param renderer Unused
         * @param path_string The tree path in string represenation
         */
        private void on_item_show_name_toggled(
            Gtk.CellRendererToggle renderer,
            string path_string
            )
        {
            change_attribute_state(
                path_string,
                (state) =>
                {
                    state.presentation = Geda3.TextPresentation.NAME;
                }
                );
        }


        /**
         * Set the presentation to show the name and value of the
         * attribute
         *
         * @param renderer Unused
         * @param path_string The tree path in string represenation
         */
        private void on_item_show_name_value_toggled(
            Gtk.CellRendererToggle renderer,
            string path_string
            )
        {
            change_attribute_state(
                path_string,
                (state) =>
                {
                    state.presentation = Geda3.TextPresentation.BOTH;
                }
                );
        }


        /**
         * Set the presentation to show the value of the attribute
         *
         * @param renderer Unused
         * @param path_string The tree path in string represenation
         */
        private void on_item_show_value_toggled(
            Gtk.CellRendererToggle renderer,
            string path_string
            )
        {
            change_attribute_state(
                path_string,
                (state) =>
                {
                    state.presentation = Geda3.TextPresentation.VALUE;
                }
                );
        }


        /**
         * Make updates to the attribute value after editing
         *
         * @param renderer Unused
         * @param path_string The tree path in string represenation
         * @param new_value The new attribute value
         */
        private void on_item_value_edited(
            Gtk.CellRendererText renderer,
            string path_string,
            string new_value
            )
        {
            change_attribute_state(
                path_string,
                (state) => { state.@value = new_value; }
                );
        }


        /**
         * Toggle the visibility of the item
         *
         * @param renderer Unused
         * @param path_string The tree path in string represenation
         */
        private void on_item_visible_toggled(
            Gtk.CellRendererToggle renderer,
            string path_string
            )
        {
            change_attribute_state(
                path_string,
                (state) => { state.visible = !state.visible; }
                );
        }


        /**
         *
         */
        private void on_remove_button_clicked()

            requires(b_item != null)
            requires(m_selection != null)

        {
            var attributes = new Gee.HashSet<Geda3.AttributeChild>();

            //Gtk.TreeModel dummy;
            //var paths = m_selection.get_selected_rows(out dummy);

            //foreach (var path in paths)
            //{
            //    var attribute = get_attribute_path(path);

            //    attributes.add(attribute);
            //}

            foreach (var attribute in attributes)
            {
                b_item.detach(attribute);
            }
        }


        /**
         *
         */
        private void on_view_selection_changed()

            requires(m_detach_button != null)
            requires(m_remove_button != null)
            requires(m_selection != null)

        {
            var count = m_selection.count_selected_rows();

            var sensitive = count > 0;

            m_detach_button.sensitive = sensitive;
            m_remove_button.sensitive = sensitive;
        }


        /**
         *
         */
        private void remove_row_path(Gtk.TreePath path)

            requires(m_selection != null)

        {
            Gtk.TreeIter iter;

            var success = m_list.get_iter(out iter, path);
            return_val_if_fail(success, null);

            m_list.remove(ref iter);
        }


        /**
         * Update the list of attributes using the selected item
         */
        private void update_attribute_list()

            requires(m_list != null)

        {
            clear_attribute_list();

            if (b_item != null)
            {
                foreach (var attribute in b_item.attributes)
                {
                    Gtk.TreeIter iter;

                    m_list.append(out iter);

                    var state = new AttributeEditing(attribute);

                    m_list.@set(iter, Column.STATE, state);

                    update_row_iter(iter);

                    // connect
                }
            }
        }


        /**
         *
         */
        private void update_insert_sensitivity()

            requires(m_insert_button != null)

        {
            var creator = b_item as Geda3.AttributeCreator;

            m_insert_button.sensitive =
                (creator != null) &&
                creator.can_create_and_attach;
        }


        /**
         *
         */
        private void update_row_iter(Gtk.TreeIter iter)

            requires(m_list != null)
            requires(m_list.iter_is_valid(iter))

        {
            var state = get_attribute_state_iter(iter);
            return_if_fail(state != null);

            m_list.@set(
                iter,
                Column.NAME,                      state.name,
                Column.NAME_EDITABLE,             true,
                Column.VALUE,                     state.@value,
                Column.VALUE_EDITABLE,            true,
                Column.VISIBLE,                   state.visible,
                Column.VISIBLE_EDITABLE,          true,
                Column.SHOW_NAME,                 state.presentation == Geda3.TextPresentation.NAME,
                Column.SHOW_NAME_EDITABLE,        true,
                Column.SHOW_VALUE,                state.presentation == Geda3.TextPresentation.VALUE,
                Column.SHOW_VALUE_EDITABLE,       true,
                Column.SHOW_NAME_VALUE,           state.presentation == Geda3.TextPresentation.BOTH,
                Column.SHOW_NAME_VALUE_EDITABLE,  true
                );
        }


        /**
         *
         */
        private void update_row_path(Gtk.TreePath path)
        {
            Gtk.TreeIter iter;

            var success = m_list.get_iter(out iter, path);
            return_val_if_fail(success, null);

            update_row_iter(iter);
        }


        private bool is_parent(Geda3.SchematicItem item)
        {
            return item is Geda3.AttributeParent;
        }


        /**
         * Update the selected item using the schematic window
         */
        private void update_selected_item()

            requires(b_schematic_window == null || b_schematic_window.selection != null)
        
        {
            var temp = Geda3.GeeEx.single_match(
                b_schematic_window.selection,
                is_parent
                );

            item = temp as Geda3.AttributeParent;
        }
    }
}
