namespace Gschem3
{
    /**
     * A combo box for selecting rotation
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/wid/ColorComboBox.ui.xml")]
    public class ColorComboBox : PropertyComboBox
    {
        /**
         * Initialize the instance
         */
        construct
        {
            model = m_color_list;
        }


        /**
         * The list store containing the available colors
         */
        [GtkChild(name="color-list")]
        private Gtk.ListStore m_color_list;
    }
}
