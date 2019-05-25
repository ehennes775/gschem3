namespace Gschem3
{
    /**
     * Allows editing of object properties
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/pedit/ColorEditor.ui.xml")]
    public class ColorEditor : Gtk.Expander, ItemEditor
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
                    b_schematic_window.color_scheme_changed.disconnect(
                        on_color_scheme_changed
                        );

                    b_schematic_window.selection_changed.disconnect(
                        on_selection_change
                        );
                }

                b_schematic_window = value;

                if (b_schematic_window != null)
                {
                    b_schematic_window.color_scheme_changed.connect(
                        on_color_scheme_changed
                        );

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
            // Ensure the type is avaialble before construction from
            // XML.

            stdout.printf("%s\n",typeof(ColorSwatchRenderer).name());
        }


        /**
         * Initialize the instance
         */
        construct
        {
            expanded = true;                       // not getting set in the XML
            label = "<b>Object Properties</b>";    // not getting set in the XML
            margin_bottom = 8;                     // not getting set in the XML
            margin_top = 8;                        // not getting set in the XML
            use_markup = true;                     // not getting set in the XML

            m_color_apply_signal_id = m_color_combo.apply.connect(
                on_apply_color
                );

            notify["schematic-window"].connect(
                on_notify_schematic_window
                );

            notify["schematic-window"].connect(
                on_notify_schematic_window_colors
                );
        }


        /**
         * {@inheritDoc}
         */
        public void update_document_window(DocumentWindow? window)
        {
            schematic_window = window as SchematicWindow;
        }


        /**
         * The columns in the list store
         *
         * These values must match the XML
         */
        private enum Column
        {
            NAME,
            ID_STRING,
            COLOR,
            INDEX
        }


        /**
         * The backing store for the schematic window property
         */
        private SchematicWindow? b_schematic_window;


        /**
         * The colorable items from the selection
         */
        private Gee.List<Geda3.AdjustableColor> m_items =
            new Gee.ArrayList<Geda3.AdjustableColor>();


        /**
         * The combo box containing the color
         */
        [GtkChild(name="color-combo")]
        private PropertyComboBox m_color_combo;


        /**
         * The combo box containing the color
         */
        [GtkChild(name="color-list")]
        private Gtk.ListStore m_model;


        /**
         * This id is used to block signal handling with updating the
         * combo box with a new value. Blocking prevents an infinite
         * loop of signal handlers.
         */
        private ulong m_color_apply_signal_id;


        /**
         * Apply a color to the selected items
         *
         * @param color The new color to apply
         */
        private void apply_color(int color)

            requires(color >= 0)
            requires(m_items != null)
            requires(m_items.all_match(i => i != null))

        {
            foreach (var item in m_items)
            {
                item.color = color;
            }
        }


        /**
         * Retrieve the color from the selection
         *
         * @param items The colorable items from the selection
         * @param pin_type The color type to apply
         * @return The state of the color data
         */
        private static ValueState fetch_color(
            Gee.Iterable<Geda3.AdjustableColor> items,
            out int color
            )

            requires(items.all_match(i => i != null))

        {
            var state = ValueState.UNAVAILABLE;
            var temp_color = Geda3.Color.BACKGROUND;

            foreach (var item in items)
            {
                if (state == ValueState.UNAVAILABLE)
                {
                    temp_color = item.color;
                    state = ValueState.AVAILABLE;
                    continue;
                }

                if (state == ValueState.AVAILABLE)
                {
                    if (temp_color != item.color)
                    {
                        state = ValueState.INCONSISTENT;
                        break;
                    }
                }
            }

            color = temp_color;

            return state;
        }


        /**
         * Signal handler for applying a new color to the selection
         */
        private void on_apply_color()

            requires(m_color_combo != null)
            requires(m_items != null)

        {
            try
            {
                var color = Geda3.Color.parse(
                    m_color_combo.active_id
                    );

                apply_color(color);
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         * Event handler for when the color scheme changes
         *
         * @param scheme The new color scheme
         */
        public void on_color_scheme_changed(Geda3.ColorScheme scheme)
        {
            update_colors(scheme);
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
         * Signal handler when the current window changes
         *
         * @param param Unused
         */
        private void on_notify_schematic_window_colors(ParamSpec param)

            requires(b_schematic_window != null)
            requires(b_schematic_window.settings != null)
            requires(b_schematic_window.settings.scheme != null)

        {
            update_colors(b_schematic_window.settings.scheme);
        }


        /**
         *
         */
        public void on_selection_change()
        {
            update();
        }


        /**
         * Update all the widgets with values from the selection
         */
        private void update()

            ensures(m_items.all_match(i => i != null))

        {
            m_items.clear();

            if ((b_schematic_window != null) && (b_schematic_window.selection != null))
            {
                foreach (var item in b_schematic_window.selection)
                {
                    var colorable = item as Geda3.AdjustableColor;

                    if (colorable == null)
                    {
                        continue;
                    }

                    m_items.add(colorable);
                }
            }

            update_color(m_items);
            update_sensitivities(m_items);
        }


        /**
         * Update the selected color in the combo widget
         *
         * @param items Colorable items in the selection
         */
        private void update_color(
            Gee.Iterable<Geda3.AdjustableColor> items
            )

            requires(m_color_combo != null)

        {
            var color = Geda3.Color.BACKGROUND;
            var state = fetch_color(items, out color);
            
            SignalHandler.block(
                m_color_combo,
                m_color_apply_signal_id
                );

            if (state.is_available())
            {
                m_color_combo.active_id = "%d".printf(color);
            }
            else
            {
                m_color_combo.active = -1;
            }

            SignalHandler.unblock(
                m_color_combo,
                m_color_apply_signal_id
                );
        }


        /**
         *
         *
         * @param scheme The new color scheme
         */
        private void update_colors(Geda3.ColorScheme scheme)

            requires(m_model != null)

        {
            var iter = Gtk.TreeIter();

            var success = m_model.get_iter_first(out iter);

            while (success)
            {
                var index = Geda3.Color.BACKGROUND;
                
                m_model.get(
                    iter,
                    Column.INDEX,
                    &index
                    );

                var color = scheme.get(index);

                m_model.set_value(
                    iter,
                    Column.COLOR,
                    color
                    );

                success = m_model.iter_next(ref iter);
            }
        }


        /**
         * Update sensitivities for combo boxes
         *
         * @param items Colorable items in the selection
         */
        private void update_sensitivities(
            Gee.Iterable<Geda3.AdjustableColor> items
            )

            requires(m_color_combo != null)

        {
            var sensitive = items.any_match(item => true);

            m_color_combo.sensitive = sensitive;
        }
    }
}
