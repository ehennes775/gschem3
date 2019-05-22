namespace Gschem3
{
    /**
     * A dialog for attributes and text
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/tdlg/TextEditorDialog.ui.xml")]
    public class TextEditorDialog : Gtk.Dialog
    {
        /**
         * The item being edited
         */
        public Geda3.TextItem? item
        {
            get
            {
                return b_item;
            }
            construct set
            {
                // TODO disconnect to notify signals after blocking is
                // implemented

                b_item = value;

                // TODO connect to notify signals after blocking is
                // implemented
            }
            default = null;
        }


        /**
         * Initialize the class
         */
        static construct
        {
            // ensure dependent types, from the UI file, are registered
            // with the type system

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
            notify["item"].connect(on_notify_rotation);

            m_alignment_combo.apply.connect(on_apply_alignment);
            m_rotation_combo.apply.connect(on_apply_rotation);
        }


        /**
         * The text alignment widget
         */
        [GtkChild(name="combo-alignment")]
        private AlignmentComboBox m_alignment_combo;


        /**
         * The text rotation widget
         */
        [GtkChild(name="combo-rotation")]
        private RotationComboBox m_rotation_combo;


        /**
         * Signal handler when the user selects an alignment
         */
        private void on_apply_alignment()

            requires(b_item != null)
            requires(m_alignment_combo != null)

        {
            b_item.alignment = m_alignment_combo.alignment;
        }


        /**
         * Signal handler when the user selects a rotation
         */
        private void on_apply_rotation()

            requires(b_item != null)
            requires(m_rotation_combo != null)

        {
            b_item.angle = m_rotation_combo.rotation;
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
         * Signal handler when the item or the item rotation changes
         *
         * @param param Unused
         */
        private void on_notify_rotation(ParamSpec param)

            requires(m_rotation_combo != null)

        {
            if (b_item != null)
            {
                m_rotation_combo.rotation = b_item.angle;
                m_rotation_combo.sensitive = true;
            }
            else
            {
                m_rotation_combo.sensitive = false;
            }
        }


        /**
         * Thebacking store for the item
         */
        private Geda3.TextItem? b_item;
    }
}
