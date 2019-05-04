namespace Gschem3
{
    /**
     * A dialog for editing pin attributes
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/dlg/PinEditorDialog.ui.xml")]
    public class PinEditorDialog : Gtk.Dialog
    {
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
                //if (b_schematic_window != null)
                //{
                //    b_schematic_window.selection_changed.disconnect(on_selection_change);
                //}

                b_schematic_window = value;

                if (b_schematic_window != null)
                {
                //    b_schematic_window.selection_changed.connect(on_selection_change);

                    update_pin_list();
                }
            }
            default = null;
        }


        /**
         *
         */
        construct
        {
            m_helpers = new Gee.ArrayList<ColumnHelper>();

            m_helpers.add(
                new ColumnHelper(
                    m_pin_list,
                    m_pin_number_renderer,
                    Column.PIN,
                    "pinnumber",
                    Column.NUMBER,
                    Column.NUMBER_CHANGED
                    ));

            m_helpers.add(
                new ColumnHelper(
                    m_pin_list,
                    m_pin_label_renderer,
                    Column.PIN,
                    "pinlabel",
                    Column.LABEL,
                    Column.LABEL_CHANGED
                    ));

            m_helpers.add(
                new ColumnHelper(
                    m_pin_list,
                    m_pin_sequence_renderer,
                    Column.PIN,
                    "pinseq",
                    Column.SEQUENCE,
                    Column.SEQUENCE_CHANGED
                    ));
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
         *
         */
        private Gee.Collection<ColumnHelper> m_helpers;


        [GtkChild(name="column-pinseq-renderer")]
        private Gtk.CellRendererText m_pin_sequence_renderer;


        [GtkChild(name="column-pinlabel-renderer")]
        private Gtk.CellRendererText m_pin_label_renderer;


        [GtkChild(name="column-pinnumber-renderer")]
        private Gtk.CellRendererText m_pin_number_renderer;


        /**
         * The ListStore containing the pins
         */
        [GtkChild(name="pin-list")]
        private Gtk.ListStore m_pin_list;


        /**
         * The backing store for the schematic window property
         */
        private SchematicWindow? b_schematic_window;


        /**
         * Clear all pins from the list
         */
        private void clear_pin_list()

            requires(m_pin_list != null)

        {
            Gtk.TreeIter iter;

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
            requires(b_schematic_window != null)

        {
            clear_pin_list();

            foreach (var item in b_schematic_window.schematic.items)
            {
                Gtk.TreeIter iter;

                m_pin_list.append(out iter);

                m_pin_list.set_value(iter, Column.PIN, item);

                foreach (var helper in m_helpers)
                {
                    helper.update(iter);
                }
            }
        }
    }
}
