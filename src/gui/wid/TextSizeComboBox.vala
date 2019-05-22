namespace Gschem3
{
    /**
     * A combo box for selecting a text size
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/wid/TextSizeComboBox.ui.xml")]
    public class TextSizeComboBox : PropertyComboBox
    {
        /**
         * The size of the text
         */
        public int size
        {
            get
            {
                m_text_size_entry = get_child() as Gtk.Entry;

                return_val_if_fail(
                    m_text_size_entry != null,
                    b_last_size
                    );

                try
                {
                    b_last_size = Geda3.TextSize.parse(
                        m_text_size_entry.text
                        );
                }
                catch (Error error)
                {
                }

                return b_last_size;
            }
            construct set
            {
                m_text_size_entry = get_child() as Gtk.Entry;

                b_last_size = value;

                return_if_fail(m_text_size_entry != null);
                m_text_size_entry.text = b_last_size.to_string();
            }
            default = 10;
        }


        /**
         * Initialize the instance
         */
        construct
        {
            model = m_text_size_list;

            // The entry widget is not available at this point
            // m_text_size_entry = get_child() as Gtk.Entry;
        }


        /**
         * The text size entry widget
         */
        private Gtk.Entry m_text_size_entry;


        /**
         * The list store containing the available text sizes
         */
        [GtkChild(name="text-size-list")]
        private Gtk.ListStore m_text_size_list;


        /**
         * The last valid size processed by this widget
         */
        private int b_last_size;
    }
}
