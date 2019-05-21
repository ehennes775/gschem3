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
                    b_schematic_window.selection_changed.disconnect(on_selection_change);
                }

                b_schematic_window = value;

                if (b_schematic_window != null)
                {
                    b_schematic_window.selection_changed.connect(on_selection_change);
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

            m_alignment_apply_signal_id = m_alignment_combo.apply.connect(
                on_apply_alignment
                );

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
         * The backing store for the schematic window property
         */
        private SchematicWindow? b_schematic_window;


        /**
         * This id is used to block signal handling with updating the
         * combo box with a new value. Blocking prevents an infinite
         * loop of signal handlers.
         */
        private ulong m_alignment_apply_signal_id;


        /**
         *
         */
        [GtkChild(name="alignment-combo")]
        private PropertyComboBox m_alignment_combo;


        /**
         *
         */
        [GtkChild(name="color-combo")]
        private PropertyComboBox m_color_combo;


        /**
         *
         */
        private Gee.List<Geda3.TextItem> m_items = new Gee.ArrayList<Geda3.TextItem>();


        /**
         *
         */
        [GtkChild(name="rotation-combo")]
        private PropertyComboBox m_rotation_combo;


        /**
         *
         */
        [GtkChild(name="size-combo")]
        private PropertyComboBox m_size_combo;


        /**
         * Apply a new property to text items
         *
         * @param applicator A delegate for applying a new property
         */
        private void apply(
            TextApplicator applicator
            )

            requires(m_items != null)
            requires(m_items.all_match(i => i != null))

        {
            foreach (var item in m_items)
            {
                applicator(item);
            }
        }


        /**
         * Retrieve the text alignment from the selection
         *
         * @param items The text items from the selection
         * @param alignment The new text alignment to apply
         * @return The state of the text alignment data
         */
        private static ValueState fetch_alignment(Gee.Iterable<Geda3.TextItem> items, out Geda3.TextAlignment alignment)
        {
            var state = ValueState.UNAVAILABLE;
            var temp_alignment = Geda3.TextAlignment.LOWER_LEFT;

            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                if (state == ValueState.UNAVAILABLE)
                {
                    temp_alignment = item.alignment;
                    state = ValueState.AVAILABLE;
                    continue;
                }

                if (state == ValueState.AVAILABLE)
                {
                    if (temp_alignment != item.alignment)
                    {
                        state = ValueState.INCONSISTENT;
                        break;
                    }
                }
            }

            alignment = temp_alignment;

            return state;
        }




        /**
         * Signal handler for applying a new text alignment to the
         * selection
         */
        private void on_apply_alignment()

            requires(m_alignment_combo != null)

        {
            try
            {
                var alignment = Geda3.TextAlignment.parse(
                    m_alignment_combo.active_id
                    );

                apply(
                    (item) => { item.alignment = alignment; }
                    );
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         * Signal handler for applying a new text color to the
         * selection
         */
        private void on_apply_color()

            requires(m_color_combo != null)

        {
            try
            {
                var color = Geda3.Color.parse(
                    m_color_combo.active_id
                    );

                apply(
                    (item) => { item.color = color; }
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
        {
            m_items.clear();

            if ((b_schematic_window != null) && (b_schematic_window.selection != null))
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

            update_alignment_combo(m_items);
            update_sensitivities(m_items);
        }


        /**
         * Update data in the text alignment combo
         *
         * @param items Text items in the selection
         */
        private void update_alignment_combo(Gee.Iterable<Geda3.TextItem> items)

            requires(m_alignment_combo != null)

        {
            var alignment = Geda3.TextAlignment.LOWER_LEFT;
            var state = fetch_alignment(items, out alignment);
            
            SignalHandler.block(
                m_alignment_combo,
                m_alignment_apply_signal_id
                );

            if (state.is_available())
            {
                m_alignment_combo.active_id = "%d".printf(alignment);
            }
            else
            {
                m_alignment_combo.active = -1;
            }

            SignalHandler.unblock(
                m_alignment_combo,
                m_alignment_apply_signal_id
                );
        }


        /**
         * Update sensitivities for combo boxes
         *
         * @param items Text items in the selection
         */
        private void update_sensitivities(Gee.Iterable<Geda3.TextItem> items)

            requires(m_alignment_combo != null)
            requires(m_color_combo != null)
            requires(m_rotation_combo != null)
            requires(m_size_combo != null)

        {
            var sensitive = items.any_match(item => true);

            m_alignment_combo.sensitive = sensitive;
            m_color_combo.sensitive = sensitive;
            m_rotation_combo.sensitive = sensitive;
            m_size_combo.sensitive = sensitive;
        }
    }
}
