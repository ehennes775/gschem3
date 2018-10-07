namespace Gschem3
{
    /**
     *
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/pedit/LineStyleEditor.ui.xml")]
    public class LineStyleEditor : Gtk.Expander, ItemEditor
    {
        /**
         * The schematic window containing the current selection
         *
         * If null, there is no current window, or the current window
         * is not editing a schematic.
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
            expanded = true;                // not getting set in the XML
            label = "<b>Line Style</b>";    // not getting set in the XML
            margin_bottom = 8;              // not getting set in the XML
            margin_top = 8;                 // not getting set in the XML
            use_markup = true;              // not getting set in the XML

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
        [GtkChild(name="cap-type-combo")]
        private PropertyComboBox m_cap_type_combo;


        /**
         *
         */
        [GtkChild(name="dash-length-combo")]
        private PropertyComboBox m_dash_length_combo;


        /**
         *
         */
        [GtkChild(name="dash-space-combo")]
        private PropertyComboBox m_dash_space_combo;


        /**
         *
         */
        [GtkChild(name="line-type-combo")]
        private PropertyComboBox m_dash_type_combo;


        /**
         *
         */
        private Gee.List<Geda3.StylableLine> m_items = new Gee.ArrayList<Geda3.StylableLine>();


        /**
         *
         */
        [GtkChild(name="width-combo")]
        private PropertyComboBox m_width_combo;


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
                    var stylable = item as Geda3.StylableLine;

                    if (stylable == null)
                    {
                        continue;
                    }

                    m_items.add(stylable);
                }
            }

            update_sensitivities(m_items);
        }


        /**
         * Update sensitivities for combo boxes
         *
         * @param items Items in the selection with sytlable lines
         */
        private void update_sensitivities(Gee.Iterable<Geda3.StylableLine> items)

            requires(m_cap_type_combo != null)
            requires(m_dash_length_combo != null)
            requires(m_dash_space_combo != null)
            requires(m_dash_type_combo != null)
            requires(m_width_combo != null)

        {
            var sensitive = items.any_match(item => true);

            m_cap_type_combo.sensitive = sensitive;

            m_dash_length_combo.sensitive = sensitive && items.any_match(
                item => item.line_style.dash_type.uses_length()
                );

            m_dash_space_combo.sensitive = sensitive && items.any_match(
                item => item.line_style.dash_type.uses_space()
                );

            m_dash_type_combo.sensitive = sensitive;

            m_width_combo.sensitive = sensitive;
        }
    }
}
