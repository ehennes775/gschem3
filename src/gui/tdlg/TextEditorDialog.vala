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
            notify["item"].connect(on_notify_alignment);

            m_alignment_combo.apply.connect(on_apply_alignment);
        }


        /**
         *
         */
        [GtkChild(name="combo-alignment")]
        private AlignmentComboBox m_alignment_combo;


        /**
         *
         */
        private void on_apply_alignment()

            requires(b_item != null)
            requires(m_alignment_combo != null)

        {
            b_item.alignment = m_alignment_combo.alignment;
        }


        /**
         * Signal handler when the item or the item alignment changes
         *
         * @param param Unused
         */
        private void on_notify_alignment(ParamSpec param)

            requires(m_alignment_combo != null)

        {
            if (b_item != null)
            {
                m_alignment_combo.alignment = b_item.alignment;
                m_alignment_combo.sensitive = true;
            }
            else
            {
                m_alignment_combo.sensitive = false;
            }
        }



        /**
         *
         */
        private Geda3.TextItem? b_item;
    }
}
