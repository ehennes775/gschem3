namespace Gschem3
{
    /**
     * A combo box for selecting rotation
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/wid/AlignmentComboBox.ui.xml")]
    public class AlignmentComboBox : PropertyComboBox
    {
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
         * The list store containing the available text alignments
         */
        [GtkChild(name="alignment-list")]
        private Gtk.ListStore m_alignment_list;
    }
}
