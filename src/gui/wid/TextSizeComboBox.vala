namespace Gschem3
{
    /**
     * A combo box for selecting rotation
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/wid/TextSizeComboBox.ui.xml")]
    public class TextSizeComboBox : PropertyComboBox
    {
        /**
         * Initialize the instance
         */
        construct
        {
            model = m_text_size_list;
        }


        /**
         * The list store containing the available text sizes
         */
        [GtkChild(name="text-size-list")]
        private Gtk.ListStore m_text_size_list;
    }
}
