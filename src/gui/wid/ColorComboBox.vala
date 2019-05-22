namespace Gschem3
{
    /**
     * A combo box for selecting rotation
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/wid/ColorComboBox.ui.xml")]
    public class ColorComboBox : PropertyComboBox
    {
        /**
         *
         */
        public int color
        {
            get
            {
                Value color;

                var success = get_active_value(
                    Column.COLOR_INDEX,
                    out color
                    );

                return_val_if_fail(success, FAIL_VALUE);

                return color.get_int();
            }
            set
            {
                set_active_by_value(
                    Column.COLOR_INDEX,
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
            model = m_color_list;
        }


        /**
         *
         */
        private int FAIL_VALUE = Geda3.Color.TEXT;


        /**
         *
         */
        private enum Column
        {
            NAME,
            UNUSED,
            COLOR,
            COLOR_INDEX,
            COUNT
        }


        /**
         * The list store containing the available colors
         */
        [GtkChild(name="color-list")]
        private Gtk.ListStore m_color_list;
    }
}
