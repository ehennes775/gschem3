namespace Gschem3
{
    /**
     *
     */
    public class PinTypeColumnHelper : ColumnHelper
    {
        /**
         *
         *
         * @param store
         * @param renderer
         * @param item_column
         * @param name
         * @param value_column
         */
        public PinTypeColumnHelper(
            Gtk.ListStore store,
            Gtk.CellRendererText renderer,
            int item_column,
            string name,
            int value_column,
            int editable_column
            )
        {
            m_editable_column = editable_column;
            m_item_column = item_column;
            m_name = name;
            m_renderer = renderer;
            m_store = store;
            m_value_column = value_column;

            m_renderer.edited.connect(on_edited);
            m_renderer.editing_started.connect(on_editing_started);
        }



        /**
         *
         */
        public override void update(Gtk.TreeIter iter)
        {
            var pin = get_pin_item(iter);
            return_if_fail(pin != null);

            var editable = false;
            var @value = "missing";

            foreach (var attribute in pin.attributes)
            {
                if (attribute.name == m_name)
                {
                    @value = attribute.@value;
                    editable = true;

                    break;
                }
            }

            m_store.set_value(iter, m_value_column, @value);
            m_store.set_value(iter, m_editable_column, editable);
        }


        /**
         *
         */
        private int m_editable_column;


        /**
         *
         */
        private string m_name;


        /**
         *
         */
        private Gtk.CellRendererText m_renderer;


        /**
         *
         */
        private int m_value_column;


        /**
         *
         *
         * @param iter
         * @return
         */
        private Geda3.PinItem get_pin_item(Gtk.TreeIter iter)
        {
            Value pin;

            m_store.get_value(iter, m_item_column, out pin);

            return pin.get_object() as Geda3.PinItem;
        }


        /**
         *
         *
         * @param path
         * @param new_text
         */
        private void on_edited(string path_string, string new_text)
        {
            Gtk.TreeIter iter;
            var path = new Gtk.TreePath.from_string(path_string);

            var success = m_store.get_iter(out iter, path);
            return_if_fail(success);

            var pin = get_pin_item(iter);
            return_if_fail(pin != null);

            foreach (var attribute in pin.attributes)
            {
                if (attribute.name == m_name)
                {
                    attribute.set_pair(m_name, new_text);

                    break;
                }
            }
        }


        /**
         * Perform additional setup on the editing widget
         *
         * @param editable The combo box
         * @param path The tree path
         */
        private void on_editing_started(
            Gtk.CellEditable editable,
            string path
            )
        {
            var combo = editable as Gtk.ComboBox;
            return_if_fail(combo != null);

            var renderer = new Gtk.CellRendererText();
            combo.pack_end(renderer, true);
            combo.add_attribute(renderer, "text", 1);
        }
    }
}
