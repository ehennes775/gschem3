namespace Gschem3
{
    /**
     *
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/pedit/TextPropertyEditor.ui.xml")]
    public class TextPropertyEditor : Gtk.Expander, ItemEditor
    {
        /**
         * The schematic window containing the current selection
         *
         * If null, there is no current window, or the current window
         * is not editing a schmeatic.
         */
        public SchematicWindow? schematic_window
        {
            get
            {
                return b_schematic_window;
            }
            construct set
            {
                if (b_schematic_window != null)
                {
                    b_schematic_window.selection_changed.disconnect(
                        on_selection_change
                        );
                }

                b_schematic_window = value;

                if (b_schematic_window != null)
                {
                    b_schematic_window.selection_changed.connect(
                        on_selection_change
                        );
                }
            }
            default = null;
        }


        /**
         * Initialize the class
         */
        static construct
        {
            stdout.printf("%s\n",typeof(AlignmentComboBox).name());
            stdout.printf("%s\n",typeof(ColorComboBox).name());
            stdout.printf("%s\n",typeof(RotationComboBox).name());
            stdout.printf("%s\n",typeof(TextSizeComboBox).name());
        }

        /**
         *
         */
        construct
        {
            expanded = true;                     // not getting set in the XML
            label = "<b>Text Properties</b>";    // not getting set in the XML
            margin_bottom = 8;                   // not getting set in the XML
            margin_top = 8;                      // not getting set in the XML
            use_markup = true;                   // not getting set in the XML

            m_alignment_combo.apply.connect(on_apply_alignment);
            m_color_combo.apply.connect(on_apply_color);
            m_rotation_combo.apply.connect(on_apply_rotation);
            m_size_combo.apply.connect(on_apply_size);

            notify["schematic-window"].connect(on_notify_schematic_window);
        }


        /**
         * {@inheritDoc}
         */
        public void update_document_window(DocumentWindow? window)
        {
            schematic_window = window as SchematicWindow;
        }


        /**
         * A delegate for applying properties to text items
         */
        private delegate void TextApplicator(
            Geda3.TextItem item
            );


        /**
         * A delegate for comparing two text items 
         */
        private delegate bool TextCompare(
            Geda3.TextItem first,
            Geda3.TextItem second
            );


        /**
         * The backing store for the schematic window property
         */
        private SchematicWindow? b_schematic_window;


        /**
         *
         */
        [GtkChild(name="alignment-combo")]
        private AlignmentComboBox m_alignment_combo;


        /**
         *
         */
        [GtkChild(name="color-combo")]
        private ColorComboBox m_color_combo;


        /**
         *
         */
        private Gee.List<Geda3.TextItem> m_items = new Gee.ArrayList<Geda3.TextItem>();


        /**
         *
         */
        [GtkChild(name="rotation-combo")]
        private RotationComboBox m_rotation_combo;


        /**
         *
         */
        [GtkChild(name="size-combo")]
        private PropertyComboBox m_size_combo;


        /**
         * Apply a new property to text items
         *
         * @param applicator A delegate for applying the new property
         */
        private void apply(TextApplicator applicator)

            requires(m_items != null)
            requires(m_items.all_match(i => i != null))

        {
            foreach (var item in m_items)
            {
                applicator(item);
            }
        }


        /**
         * Fetch a consistent text item
         *
         * @param compare A delegate to compare item properties
         * @return The consistent text item, or null if none
         */
        private Geda3.TextItem? fetch(TextCompare compare)

            requires(m_items != null)
            requires(m_items.all_match(i => i != null))

        {
            var first = m_items.first_match(i => true);

            if (first != null)
            {
                var matching = m_items.all_match(
                    i => compare(first, i)
                    );

                if (!matching)
                {
                    first = null;
                }
            }

            return first;
        }


        /**
         * Signal handler for applying a new text alignment to the
         * selection
         */
        private void on_apply_alignment()

            requires(m_alignment_combo != null)
            requires(m_alignment_combo.active >= 0)

        {
            var alignment = m_alignment_combo.alignment;

            apply(
                (item) => { item.alignment = alignment; }
                );
        }


        /**
         * Signal handler for applying a new text color to the
         * selection
         */
        private void on_apply_color()

            requires(m_color_combo != null)
            requires(m_color_combo.active >= 0)

        {
            var color = m_color_combo.color;

            apply(
                (item) => { item.color = color; }
                );
        }


        /**
         * Signal handler for applying a new rotation to the
         * selection
         */
        private void on_apply_rotation()

            requires(m_rotation_combo != null)
            requires(m_rotation_combo.active >= 0)

        {
            var rotation = m_rotation_combo.rotation;

            apply(
                (item) => { item.angle = rotation; }
                );
        }


        /**
         * Signal handler for applying a new text size to the
         * selection
         */
        private void on_apply_size()

            requires(m_size_combo != null)

        {
            try
            {
                var size = Geda3.TextSize.parse(m_size_combo.content);

                apply(
                    (item) => { item.size = size; }
                    );
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         *
         *
         * @param param Unused
         */
        private void on_notify_schematic_window(ParamSpec param)
        {
            update();
        }


        /**
         *
         */
        public void on_selection_change()
        {
            update();
        }


        /**
         *
         */
        private void update()

            requires((b_schematic_window == null) || (b_schematic_window.selection != null))

        {
            m_items.clear();

            if (b_schematic_window != null)
            {
                foreach (var item in b_schematic_window.selection)
                {
                    var text = item as Geda3.TextItem;

                    if (text == null)
                    {
                        continue;
                    }

                    m_items.add(text);
                }
            }

            update_alignment_combo();
            update_color_combo();
            update_size_combo();
            update_rotation_combo();
        }


        /**
         * Update the alignment combo box state
         */
        private void update_alignment_combo()

            requires(m_alignment_combo != null)
            requires(m_items != null)

        {
            var sensitive = m_items.any_match(item => true);

            m_alignment_combo.sensitive = sensitive;

            if (sensitive)
            {
                var item = fetch(
                    (first, item) => { return first.alignment == item.alignment; }
                    );
                
                //SignalHandler.block(
                //    m_alignment_combo,
                //    m_alignment_apply_signal_id
                //    );

                if (item != null)
                {
                    m_alignment_combo.alignment = item.alignment;
                }
                else
                {
                    m_alignment_combo.active = -1;
                }

                //SignalHandler.unblock(
                //    m_alignment_combo,
                //    m_alignment_apply_signal_id
                //    );
            }
            else
            {
                m_alignment_combo.active = -1;
            }
        }


        /**
         * Update the text color combo box state
         */
        private void update_color_combo()

            requires(m_color_combo != null)
            requires(m_items != null)

        {
            var sensitive = m_items.any_match(item => true);

            m_color_combo.sensitive = sensitive;

            if (sensitive)
            {
                var item = fetch(
                    (first, item) => { return first.color == item.color; }
                    );
                
                if (item != null)
                {
                    m_color_combo.color = item.color;
                }
                else
                {
                    m_color_combo.active = -1;
                }
            }
            else
            {
                m_color_combo.active = -1;
            }
        }


        /**
         * Update the text size combo box state
         */
        private void update_size_combo()

            requires(m_items != null)
            requires(m_size_combo != null)

        {
            var sensitive = m_items.any_match(item => true);

            m_size_combo.sensitive = sensitive;

            if (sensitive)
            {
                var item = fetch(
                    (first, item) => { return first.size == item.size; }
                    );
                
                if (item != null)
                {
                    m_size_combo.content = item.size.to_string();
                }
                else
                {
                    m_size_combo.content = "";
                }
            }
            else
            {
                m_size_combo.content = "";
            }
        }


        /**
         * Update the rotation combo box state
         */
        private void update_rotation_combo()

            requires(m_items != null)
            requires(m_rotation_combo != null)

        {
            var sensitive = m_items.any_match(item => true);

            m_rotation_combo.sensitive = sensitive;

            if (sensitive)
            {
                var item = fetch(
                    (first, item) => { return first.angle == item.angle; }
                    );
                
                if (item != null)
                {
                    m_rotation_combo.rotation = item.angle;
                }
                else
                {
                    m_rotation_combo.active = -1;
                }
            }
            else
            {
                m_rotation_combo.active = -1;
            }
        }
    }
}
