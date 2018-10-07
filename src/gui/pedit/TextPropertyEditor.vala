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
                b_schematic_window = value;
            }
            default = null;
        }


        /**
         *
         */
        static construct
        {
            stdout.printf("%s\n",typeof(PropertyComboBox).name());
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
         * The backing store for the schematic window property
         */
        private SchematicWindow? b_schematic_window;


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
         *
         *
         * @param items The items to apply a new alignment
         * @param alignment The new alignment to apply
         */
        private static void apply_alignment(Gee.Iterable<Geda3.TextItem> items, Geda3.TextAlignment alignment)

            requires(alignment >= 0)
            requires(alignment <= Geda3.TextAlignment.COUNT)

        {
            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                item.alignment = alignment;
            }
        }


        /**
         *
         *
         * @param items The items to apply a new alignment
         * @param alignment The new alignment to apply
         */
        private static void apply_color(Gee.Iterable<Geda3.TextItem> items, int color)

            requires(color >= Geda3.Color.MIN)
            requires(color <= Geda3.Color.MAX)

        {
            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                item.color = color;
            }
        }


        /**
         *
         *
         * @param items The items to apply a new rotation
         * @param rotation The new rotation to apply
         */
        private static void apply_rotation(Gee.Iterable<Geda3.TextItem> items, int rotation)
        {
            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                item.angle = rotation;
            }
        }


        /**
         *
         *
         * @param items The items to apply a new text size
         * @param size The new text size to apply
         */
        private static void apply_size(Gee.Iterable<Geda3.TextItem> items, int size)

            requires(size >= Geda3.TextSize.MIN)
            requires(size <= Geda3.TextSize.MAX)

        {
            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                item.size = size;
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

            update_sensitivities(m_items);
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
