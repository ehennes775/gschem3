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
                return_val_if_fail(m_alignment_list != null, FAIL_VALUE);

                Gtk.TreeIter iter;

                var success = m_alignment_list.iter_nth_child(
                    out iter,
                    null,
                    get_active()
                    );

                return_val_if_fail(success, FAIL_VALUE);

                Value alignment;

                m_alignment_list.get_value(
                    iter,
                    1,
                    out alignment
                    );

                return (Geda3.TextAlignment) alignment.get_enum();
            }
            set
            {
                Gtk.TreeIter iter;

                var success = m_alignment_list.get_iter_first(out iter);

                while (success)
                {
                    Value alignment;

                    m_alignment_list.get_value(
                        iter,
                        1,
                        out alignment
                        );

                    var temp = (Geda3.TextAlignment) alignment.get_enum();

                    if (temp == value)
                    {
                        set_active_iter(iter);
                    }

                    success = m_alignment_list.iter_next(ref iter);
                }
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
         * The list store containing the available text alignments
         */
        [GtkChild(name="alignment-list")]
        private Gtk.ListStore m_alignment_list;
    }
}
