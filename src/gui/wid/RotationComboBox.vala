namespace Gschem3
{
    /**
     * A combo box for selecting rotation
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/wid/RotationComboBox.ui.xml")]
    public class RotationComboBox : PropertyComboBox
    {
        /**
         * Initialize the instance
         */
        construct
        {
            model = m_rotation_list;
        }


        /**
         * The list store containing the available rotation angles
         */
        [GtkChild(name="rotation-list")]
        private Gtk.ListStore m_rotation_list;
    }
}
