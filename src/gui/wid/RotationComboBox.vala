namespace Gschem3
{
    /**
     * A combo box for selecting rotation
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/wid/RotationComboBox.ui.xml")]
    public class RotationComboBox : PropertyComboBox
    {
        /**
         *
         */
        public int rotation
        {
            get
            {
                Value rotation;

                var success = get_active_value(
                    Column.ROTATION,
                    out rotation
                    );

                return_val_if_fail(success, FAIL_VALUE);

                return rotation.get_int();
            }
            set
            {
                set_active_by_value(
                    Column.ROTATION,
                    (v) =>
                    {
                        return value == v.get_int();
                    }
                    );
            }
        }


        /**
         * Initialize the instance
         */
        construct
        {
            model = m_rotation_list;
        }


        /**
         *
         */
        private int FAIL_VALUE = 0;


        /**
         *
         */
        private enum Column
        {
            NAME,
            ROTATION,
            COUNT
        }


        /**
         * The list store containing the available rotation angles
         */
        [GtkChild(name="rotation-list")]
        private Gtk.ListStore m_rotation_list;
    }
}
