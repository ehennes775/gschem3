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

            m_selection = m_view.get_selection();

            m_selection.mode = Gtk.SelectionMode.MULTIPLE;
            m_selection.changed.connect(on_view_selection_changed);

            m_remove_button.sensitive = false;
            m_remove_button.clicked.connect(on_remove_button_clicked);
        }


        /**
         * {@inheritDoc}
         */
        public void update_document_window(DocumentWindow? window)
        {
            schematic_window = window as SchematicWindow;
        }


        /**
         * The columns in the list store
         *
         * This enumeration must be kept in sync with the UI XML.
         */
        private enum Column
        {
            ITEM,
            NAME,
            NAME_EDITABLE,
            VALUE,
            VALUE_EDITABLE
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
         * The button to remove attributes
         */
        [GtkChild(name="remove-button")]
        private Gtk.Button m_remove_button;


        /**
         * The tree view selection containing the attributes
         */
        private Gtk.TreeSelection m_selection;


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
         * Get the attribute from the model using an iterator
         *
         * @param iter The iterator of the node in the model
         * @return The attribute
         */
        private Geda3.AttributeChild get_attribute_iter(
            Gtk.TreeIter iter
            )

            requires(m_list != null)
            requires(m_list.iter_is_valid(iter))

        {
            Value @value;

            m_list.get_value(iter, Column.ITEM, out @value);

            return @value.get_object() as Geda3.AttributeChild;
        }


        /**
         * Get the attribute from the model using a path
         *
         * @param path The path to the node in the model
         * @return The attribute
         */
        private Geda3.AttributeChild get_attribute_path(
            Gtk.TreePath path
            )

            requires(m_list != null)

        {
            Gtk.TreeIter iter;

            var success = m_list.get_iter(out iter, path);
            return_val_if_fail(success, null);

            return get_attribute_iter(iter);
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
            var path = new Gtk.TreePath.from_string(path_string);

            var attribute = get_attribute_path(path);
            return_if_fail(attribute != null);

            var @value = attribute.@value;
            return_if_fail(@value != null);

            attribute.set_pair(new_name, @value);
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
            var path = new Gtk.TreePath.from_string(path_string);

            var attribute = get_attribute_path(path);
            return_if_fail(attribute != null);

            var name = attribute.name;
            return_if_fail(name != null);

            attribute.set_pair(name, new_value);
        }


        /**
         *
         */
        private void on_remove_button_clicked()

            requires(b_item != null)
            requires(m_selection != null)

        {
            var attributes = new Gee.HashSet<Geda3.AttributeChild>();
            Gtk.TreeModel dummy;

            foreach (var path in m_selection.get_selected_rows(out dummy))
            {
                var attribute = get_attribute_path(path);

                attributes.add(attribute);
            }

            foreach (var attribute in attributes)
            {
                b_item.detach(attribute);
            }
        }


        /**
         *
         */
        private void on_view_selection_changed()

            requires(m_remove_button != null)
            requires(m_selection != null)

        {
            var count = m_selection.count_selected_rows();

            m_remove_button.sensitive = count > 0;
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

                    m_list.@set(
                        iter,
                        Column.ITEM,           attribute,
                        Column.NAME,           attribute.name ?? missing_text,
                        Column.NAME_EDITABLE,  attribute.name != null,
                        Column.VALUE,          attribute.@value ?? missing_text,
                        Column.VALUE_EDITABLE, attribute.@value != null
                        );

                    // connect
                }
            }
        }


        /**
         * Update the selected item using the schematic window
         */
        private void update_selected_item()

            requires(b_schematic_window == null || b_schematic_window.selection != null)
        
        {
            var single_item_available =
                (b_schematic_window != null) &&
                (b_schematic_window.selection.size == 1);

            if (single_item_available)
            {
                item = b_schematic_window.selection.first_match(
                    i => true
                    );
            }
            else
            {
                item = null;
            }
        }
    }
}
