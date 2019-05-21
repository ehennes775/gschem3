namespace Gschem3
{
    /**
     * A dialog for attributes and text
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/tdlg/TextEditorDialog.ui.xml")]
    public class TextEditorDialog : Gtk.Dialog
    {
        /**
         *
         */
        public Geda3.TextItem? item
        {
            get
            {
                return b_item;
            }
            construct set
            {
                b_item = value;
            }
            default = null;
        }


        /**
         *
         */
        static construct
        {
            stdout.printf("%s\n",typeof(AlignmentComboBox).name());
            stdout.printf("%s\n",typeof(ColorComboBox).name());
            stdout.printf("%s\n",typeof(RotationComboBox).name());
            stdout.printf("%s\n",typeof(TextSizeComboBox).name());
        }


        /**
         * Initialize the instance
         */
        construct
        {
        }


        /**
         *
         */
        private Geda3.TextItem? b_item;
    }
}
