namespace Gschem3
{
    /**
     *
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/pedit/PinPropertyEditor.ui.xml")]
    public class PinPropertyEditor : Gtk.Expander, ItemEditor
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


        construct
        {
            expanded = true;                    // not getting set in the XML
            label = "<b>Pin Properties</b>";    // not getting set in the XML
            margin_bottom = 8;                  // not getting set in the XML
            margin_top = 8;                     // not getting set in the XML
            use_markup = true;                  // not getting set in the XML

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
        private Gee.List<Geda3.PinItem> m_items = new Gee.ArrayList<Geda3.PinItem>();


        /**
         *
         */
        [GtkChild(name="pin-type-combo")]
        private PropertyComboBox m_pin_type_combo;


        /**
         *
         *
         * @param items The items to apply a new fill type
         * @param fill_type The new fill type to apply
         */
        private static void apply_pin_type(Gee.Iterable<Geda3.PinItem> items, Geda3.PinType pin_type)

            requires(pin_type >= 0)
            requires(pin_type < Geda3.PinType.COUNT)

        {
            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                item.pin_type = pin_type;
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
                    var pin = item as Geda3.PinItem;

                    if (pin == null)
                    {
                        continue;
                    }

                    m_items.add(pin);
                }
            }

            update_sensitivities(m_items);
        }


        /**
         * Update sensitivities for combo boxes
         *
         * @param items Pin items in the selection
         */
        private void update_sensitivities(Gee.Iterable<Geda3.PinItem> items)

            requires(m_pin_type_combo != null)

        {
            var sensitive = items.any_match(item => true);

            m_pin_type_combo.sensitive = sensitive;
        }
    }
}
