namespace Gschem3
{
    /**
     * Allows editing of pin item properties
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
         * Initialize the instance
         */
        construct
        {
            expanded = true;                    // not getting set in the XML
            label = "<b>Pin Properties</b>";    // not getting set in the XML
            margin_bottom = 8;                  // not getting set in the XML
            margin_top = 8;                     // not getting set in the XML
            use_markup = true;                  // not getting set in the XML

            m_pin_type_apply_signal_id = m_pin_type_combo.apply.connect(
                on_apply_pin_type
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
         * The backing store for the schematic window property
         */
        private SchematicWindow? b_schematic_window;


        /**
         * The pin type items from the selection
         */
        private Gee.List<Geda3.PinItem> m_items = new Gee.ArrayList<Geda3.PinItem>();


        /**
         * The combo box containing the pin type
         */
        [GtkChild(name="pin-type-combo")]
        private PropertyComboBox m_pin_type_combo;


        /**
         * This id is used to block signal handling with updating the
         * combo box with a new value. Blocking prevents an infinite
         * loop of signal handlers.
         */
        private ulong m_pin_type_apply_signal_id;


        /**
         * Apply a new pin type to a set of items
         *
         * @param items The pin items from the selection
         * @param pin_type The new pin type to apply
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
         * Retrieve the pin type from the selection
         *
         * @param items The pin items from the selection
         * @param pin_type The new pin type to apply
         * @return The state of the pin type data
         */
        private static ValueState fetch_pin_type(Gee.Iterable<Geda3.PinItem> items, out Geda3.PinType pin_type)
        {
            var state = ValueState.UNAVAILABLE;
            var temp_pin_type = Geda3.PinType.NET;

            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                if (state == ValueState.UNAVAILABLE)
                {
                    temp_pin_type = item.pin_type;
                    state = ValueState.AVAILABLE;
                    continue;
                }

                if (state == ValueState.AVAILABLE)
                {
                    if (temp_pin_type != item.pin_type)
                    {
                        state = ValueState.INCONSISTENT;
                        break;
                    }
                }
            }

            pin_type = temp_pin_type;

            return state;
        }


        /**
         * Signal handler for applying a new pin type to the selection
         */
        private void on_apply_pin_type()

            requires(m_items != null)
            requires(m_pin_type_combo != null)

        {
            try
            {
                var pin_type = Geda3.PinType.parse(m_pin_type_combo.active_id);

                apply_pin_type(m_items, pin_type);
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         * Signal handler when the current window changes
         *
         * @param param Unused
         */
        private void on_notify_schematic_window(ParamSpec param)
        {
            update();
        }


        /**
         * Update all the widgets with values from the selection
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

            update_pin_type(m_items);
            update_sensitivities(m_items);
        }


        /**
         * Update data in the pin type combo
         *
         * @param items Pin items in the selection
         */
        private void update_pin_type(Gee.Iterable<Geda3.PinItem> items)

            requires(m_pin_type_combo != null)

        {
            var pin_type = Geda3.PinType.NET;
            var state = fetch_pin_type(items, out pin_type);
            
            SignalHandler.block(
                m_pin_type_combo,
                m_pin_type_apply_signal_id
                );


            if (state.is_available())
            {
                m_pin_type_combo.active_id = "%d".printf(pin_type);
            }
            else
            {
                m_pin_type_combo.active = -1;
            }

            SignalHandler.unblock(
                m_pin_type_combo,
                m_pin_type_apply_signal_id
                );
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
