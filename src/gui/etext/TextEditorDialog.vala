namespace Gschem3
{
    /**
     * A dialog for text items in schematics
     *
     * This dialog edits both attributes and text. Also, this dialog
     * switches between the two types as needed.
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/etext/TextEditorDialog.ui.xml")]
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
            // Ensure dependent types, from the UI file, are registered
            // with the type system before the builder parses the file.

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
            notify["item"].connect(on_notify_attribute);
            notify["item"].connect(on_notify_attribute_name);
            notify["item"].connect(on_notify_attribute_value);
            notify["item"].connect(on_notify_color);
            notify["item"].connect(on_notify_presentation);
            notify["item"].connect(on_notify_rotation);
            notify["item"].connect(on_notify_size);
            notify["item"].connect(on_notify_text_value);
            notify["item"].connect(on_notify_visibility);

            // attribute name - updated every character
            m_attribute_name_entry.buffer.inserted_text.connect(
                on_apply_attribute_name
                );
            m_attribute_name_entry.buffer.deleted_text.connect(
                on_apply_attribute_name
                );

            // attribute value - updated every character
            m_attribute_value_view.buffer.changed.connect(
                on_apply_attribute_value
                );

            // attribute presentation
            m_show_name_radio.toggled.connect(on_apply_presentation);
            m_show_name_value_radio.toggled.connect(on_apply_presentation);
            m_show_value_radio.toggled.connect(on_apply_presentation);

            // attribute visiblity
            m_hidden_radio.toggled.connect(on_apply_visibility);
            m_visible_radio.toggled.connect(on_apply_visibility);

            // text value - updated every character
            m_text_view.buffer.changed.connect(
                on_apply_text_value
                );

            // text properties
            m_alignment_combo.apply.connect(on_apply_alignment);
            m_color_combo.apply.connect(on_apply_color);
            m_rotation_combo.apply.connect(on_apply_rotation);
            m_size_combo.apply.connect(on_apply_size);
        }


        /**
         * The attribute name combo
         */
        [GtkChild(name="combo-attribute-name")]
        private Gtk.ComboBox m_attribute_name_combo;


        /**
         * The attribute name entry
         */
        [GtkChild(name="entry-attribute-name")]
        private Gtk.Entry m_attribute_name_entry;


        /**
         * The attribute name entry
         */
        [GtkChild(name="entry-attribute-value")]
        private Gtk.TextView m_attribute_value_view;


        /**
         * The text alignment widget
         */
        [GtkChild(name="combo-alignment")]
        private AlignmentComboBox m_alignment_combo;


        /**
         * The text color widget
         */
        [GtkChild(name="combo-color")]
        private ColorComboBox m_color_combo;


        /**
         * The hidden radio button
         */
        [GtkChild(name="radio-hidden")]
        private Gtk.RadioButton m_hidden_radio;


        /**
         * The text rotation widget
         */
        [GtkChild(name="combo-rotation")]
        private RotationComboBox m_rotation_combo;


        /**
         * The radio button that shows the name only
         */
        [GtkChild(name="radio-name")]
        private Gtk.RadioButton m_show_name_radio;


        /**
         * The radio button that shows the value only
         */
        [GtkChild(name="radio-value")]
        private Gtk.RadioButton m_show_value_radio;


        /**
         * The radio button that shows the name and value
         */
        [GtkChild(name="radio-name-value")]
        private Gtk.RadioButton m_show_name_value_radio;


        /**
         * The text size widget
         */
        [GtkChild(name="combo-size")]
        private TextSizeComboBox m_size_combo;


        /**
         * The widget used to switch between attributes and text
         */
        [GtkChild(name="stack")]
        private Gtk.Stack m_stack;


        /**
         * The widget used to switch between attributes and text
         */
        [GtkChild(name="entry-text")]
        private Gtk.TextView m_text_view;


        /**
         * The visible radio button
         */
        [GtkChild(name="radio-visible")]
        private Gtk.RadioButton m_visible_radio;


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
         * Signal handler when the user enters an attribute name
         */
        private void on_apply_attribute_name()

            requires(b_item != null)
            requires(m_attribute_name_entry != null)
            requires(m_attribute_name_entry.buffer != null)
            requires(m_attribute_value_view != null)
            requires(m_attribute_value_view.buffer != null)

        {
            b_item.set_pair(
                m_attribute_name_entry.buffer.text,
                m_attribute_value_view.buffer.text
                );
        }


        /**
         * Signal handler when the user enters an attribute value
         */
        private void on_apply_attribute_value()

            requires(b_item != null)
            requires(m_attribute_name_entry != null)
            requires(m_attribute_name_entry.buffer != null)
            requires(m_attribute_value_view != null)
            requires(m_attribute_value_view.buffer != null)

        {
            b_item.set_pair(
                m_attribute_name_entry.buffer.text,
                m_attribute_value_view.buffer.text
                );
        }


        /**
         * Signal handler when the user selects a color
         */
        private void on_apply_color()

            requires(b_item != null)
            requires(m_color_combo != null)

        {
            b_item.color = m_color_combo.color;
        }


        /**
         * Signal handler when the user selects a presentation
         */
        private void on_apply_presentation()

            requires(b_item != null)
            requires(m_show_name_radio != null)
            requires(m_show_value_radio != null)
            requires(m_show_name_value_radio != null)

        {
            if (m_show_name_radio.active)
            {
                b_item.presentation = Geda3.TextPresentation.NAME;
            }

            if (m_show_value_radio.active)
            {
                b_item.presentation = Geda3.TextPresentation.VALUE;
            }

            if (m_show_name_value_radio.active)
            {
                b_item.presentation = Geda3.TextPresentation.BOTH;
            }
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
         * Signal handler when the user selects a text size
         */
        private void on_apply_size()

            requires(b_item != null)
            requires(m_size_combo != null)

        {
            b_item.size = m_size_combo.size;
        }


        /**
         * Signal handler when the user enters an attribute value
         */
        private void on_apply_text_value()

            requires(b_item != null)
            requires(m_text_view != null)
            requires(m_text_view.buffer != null)

        {
            b_item.text = m_text_view.buffer.text;
        }


        /**
         * Signal handler when the user selects a visibility
         */
        private void on_apply_visibility()

            requires(b_item != null)
            requires(m_hidden_radio != null)
            requires(m_visible_radio != null)

        {
            if (m_hidden_radio.active)
            {
                b_item.visibility = Geda3.Visibility.INVISIBLE;
            }

            if (m_visible_radio.active)
            {
                b_item.visibility = Geda3.Visibility.VISIBLE;
            }
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
         * Signal handler when the item changes or the item switches
         * between an attribute and text
         *
         * @param param Unused
         */
        private void on_notify_attribute(ParamSpec param)

            requires(m_stack != null)

        {
            if (b_item != null)
            {
                var attribute = b_item.name != null;

                if (attribute)
                {
                    stdout.printf("attribute-widgets\n");
                    m_stack.visible_child_name = "attribute-widgets";
                }
                else
                {
                    stdout.printf("text-widgets\n");
                    m_stack.visible_child_name = "text-widgets";
                }
            }
        }


        /**
         * Signal handler when the item or the attribute name changes
         *
         * @param param Unused
         */
        private void on_notify_attribute_name(ParamSpec param)

            requires(m_attribute_name_combo != null)
            requires(m_attribute_name_entry != null)
            requires(m_attribute_name_entry.buffer != null)

        {
            if ((b_item != null) && (b_item.name != null))
            {
                // compile error - probably issue with bindings
                //m_attribute_name_entry.text = b_item.name;

                m_attribute_name_combo.sensitive = true;
            }
            else
            {
                // compile error - probably issue with bindings
                //m_attribute_name_entry.text = "".data;

                m_attribute_name_combo.sensitive = false;
            }
        }


        /**
         * Signal handler when the item or the attribute value changes
         *
         * @param param Unused
         */
        private void on_notify_attribute_value(ParamSpec param)

            requires(m_attribute_value_view != null)
            requires(m_attribute_value_view.buffer != null)

        {
            if ((b_item != null) && (b_item.@value != null))
            {
                m_attribute_value_view.buffer.text = b_item.value;
                m_attribute_value_view.sensitive = true;
            }
            else
            {
                m_attribute_value_view.buffer.text = "";
                m_attribute_value_view.sensitive = false;
            }
        }


        /**
         * Signal handler when the item or the item color changes
         *
         * @param param Unused
         */
        private void on_notify_color(ParamSpec param)

            requires(m_color_combo != null)

        {
            if (b_item != null)
            {
                m_color_combo.color = b_item.color;
                m_color_combo.sensitive = true;
            }
            else
            {
                m_color_combo.sensitive = false;
            }
        }


        /**
         * Signal handler when the item or the item presentation
         * changes
         *
         * @param param Unused
         */
        private void on_notify_presentation(ParamSpec param)

            requires(m_show_name_radio != null)
            requires(m_show_value_radio != null)
            requires(m_show_name_value_radio != null)

        {
            if (b_item != null)
            {
                switch (b_item.presentation)
                {
                    case Geda3.TextPresentation.NAME:
                        m_show_name_radio.active = true;
                        break;

                    case Geda3.TextPresentation.VALUE:
                        m_show_value_radio.active = true;
                        break;

                    case Geda3.TextPresentation.BOTH:
                        m_show_name_value_radio.active = true;
                        break;

                    default:
                        assert_not_reached();
                        break;
                }

                m_show_name_radio.sensitive = true;
                m_show_value_radio.sensitive = true;
                m_show_name_value_radio.sensitive = true;
            }
            else
            {
                m_show_name_radio.sensitive = false;
                m_show_value_radio.sensitive = false;
                m_show_name_value_radio.sensitive = false;
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
         * Signal handler when the item or the item text size changes
         *
         * @param param Unused
         */
        private void on_notify_size(ParamSpec param)

            requires(m_size_combo != null)

        {
            if (b_item != null)
            {
                m_size_combo.size = b_item.size;
                m_size_combo.sensitive = true;
            }
            else
            {
                m_size_combo.sensitive = false;
            }
        }


        /**
         * Signal handler when the item or the item text
         *
         * @param param Unused
         */
        private void on_notify_text_value(ParamSpec param)

            requires(m_text_view != null)
            requires(m_text_view.buffer != null)

        {
            if ((b_item != null) && (b_item.text != null))
            {
                m_text_view.buffer.text = b_item.text;
                m_text_view.sensitive = true;
            }
            else
            {
                m_text_view.buffer.text = "";
                m_text_view.sensitive = false;
            }
        }


        /**
         * Signal handler when the item or the item visibility changes
         *
         * @param param Unused
         */
        private void on_notify_visibility(ParamSpec param)

            requires(m_hidden_radio != null)
            requires(m_visible_radio != null)

        {
            if (b_item != null)
            {
                switch (b_item.visibility)
                {
                    case Geda3.Visibility.INVISIBLE:
                        m_hidden_radio.active = true;
                        break;

                    case Geda3.Visibility.VISIBLE:
                        m_visible_radio.active = true;
                        break;

                    default:
                        assert_not_reached();
                        break;
                }

                m_hidden_radio.sensitive = true;
                m_visible_radio.sensitive = true;
            }
            else
            {
                m_hidden_radio.sensitive = false;
                m_visible_radio.sensitive = false;
            }
        }


        /**
         * Thebacking store for the item
         */
        private Geda3.TextItem? b_item;
    }
}
