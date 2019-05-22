namespace Gschem3
{
    /**
     * A combo box for selecting rotation
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/wid/AlignmentComboBox.ui.xml")]
    public class AlignmentComboBox : PropertyComboBox
    {
        /**
         *
         */
        public Geda3.TextAlignment alignment
        {
            get
            {
                Value alignment;

                var success = get_active_value(
                    Column.ALIGNMENT,
                    out alignment
                    );

                return_val_if_fail(success, FAIL_VALUE);

                return Geda3.TextAlignment.from_value(alignment);
            }
            set
            {
                set_active_by_value(
                    Column.ALIGNMENT,
                    (v) =>
                    {
                        return value == Geda3.TextAlignment.from_value(v);
                    }
                    );
            }
        }


        /**
         * Initialize the class
         */
        static construct
        {
            stdout.printf("%s\n",typeof(Geda3.TextAlignment).name());
        }


        /**
         * Initialize the instance
         */
        construct
        {
            model = m_alignment_list;
            wrap_width = 3;
        }


        /**
         *
         */
        private Geda3.TextAlignment FAIL_VALUE = Geda3.TextAlignment.LOWER_LEFT;


        /**
         *
         */
        private enum Column
        {
            NAME,
            ALIGNMENT,
            COUNT
        }

        /**
         * The list store containing the available text alignments
         */
        [GtkChild(name="alignment-list")]
        private Gtk.ListStore m_alignment_list;
    }
}
