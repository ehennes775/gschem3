namespace Gschem3
{
    /**
     * A dialog for editing pin attributes
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/dlg/PinEditorDialog.ui.xml")]
    public class PinEditorDialog : Gtk.Dialog
    {
        /**
         * The columns in the list store
         *
         * These items must be kept in sync with the columns in the
         * UI XML.
         */
        private enum Column
        {
            PIN,
            NUMBER,
            NUMBER_CHANGED,
            LABEL,
            LABEL_CHANGED,
            SEQUENCE,
            SEQUENCE_CHANGED,
            TYPE,
            TYPE_CHANGED,
            COUNT
        }


        /**
         * The ListStore containing the pins
         */
        [GtkChild(name="pin-list")]
        private Gtk.ListStore m_pin_list;


        /**
         * The schematic window containing the pins
         */
        private SchematicWindow? m_schematic_window; 


        /**
         * Clear all pins from the list
         */
        private void clear_pin_list()

            requires(m_pin_list != null)

        {
            GtkTreeIter iter;

            var success = m_pin_list.get_iter_first(out iter);

            while (success)
            {
                // disconnect

                success = m_pin_list.iter_next(ref iter);
            }

            m_pin_list.clear();
        }


        /**
         * Update pins to match the schematic
         */
        private void update_pin_list()

            requires(m_pin_list != null)
            requires(m_schematic_window != null)

        {
            clear_pin_list();

            foreach (var item in m_schematic_window.schematic.items)
            {
                Gtk.TreeIter iter;

                m_pin_list.append(out iter);

                m_pin_list.set_value(
                    iter,
                    Column.PIN,
                    item
                    );

                m_pin_list.set_value(
                    iter,
                    Column.NUMBER,
                    "Hello"
                    );

                m_pin_list.set_value(
                    iter,
                    Column.NUMBER_CHANGED,
                    false
                    );

                m_pin_list.set_value(
                    iter,
                    Column.LABEL,
                    "Hello"
                    );

                m_pin_list.set_value(
                    iter,
                    Column.LABEL_CHANGED,
                    false
                    );

                m_pin_list.set_value(
                    iter,
                    Column.SEQUENCE,
                    "Hello"
                    );

                m_pin_list.set_value(
                    iter,
                    Column.SEQUENCE_CHANGED,
                    false
                    );

                m_pin_list.set_value(
                    iter,
                    Column.TYPE,
                    "Hello"
                    );

                m_pin_list.set_value(
                    iter,
                    Column.TYPE_CHANGED,
                    false
                    );
            }
        }
    }
}
