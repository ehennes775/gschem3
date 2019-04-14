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

            m_apply_signal_ids = new ulong[]
            {
                m_cap_type_combo.apply.connect(on_apply_cap_type),
                m_dash_length_combo.apply.connect(on_apply_dash_length),
                m_dash_space_combo.apply.connect(on_apply_dash_space),
                m_dash_type_combo.apply.connect(on_apply_dash_type),
                m_width_combo.apply.connect(on_apply_width)
            };

            notify["schematic-window"].connect(on_notify_schematic_window);
        }


        /**
         *
         */
        [CCode(has_target=false)]
        private delegate ValueState Fetcher(
            Gee.Iterable<Geda3.StylableLine> items,
            out int @value
            );


        /**
         * Apply a new cap type to the selected items
         *
         * @param items The items with stylable line properties
         * @param cap_type The cap type
         */
        private static void apply_cap_type(
            Gee.Iterable<Geda3.StylableLine> items,
            Geda3.CapType cap_type
            )

            requires(items.all_match(i => i != null))
            requires(items.all_match(i => i.line_style != null))

        {
            foreach (var item in items)
            {
                item.line_style.cap_type = cap_type;
            }
        }


        /**
         * Apply a new dash length to the selected items
         *
         * @param items The items with stylable line properties
         * @param dash_length The length of the dashes
         */
        private static void apply_dash_length(
            Gee.Iterable<Geda3.StylableLine> items,
            int dash_length
            )

            requires(items.all_match(i => i != null))
            requires(items.all_match(i => i.line_style != null))

        {
            foreach (var item in items)
            {
                item.line_style.dash_length = dash_length;
            }
        }


        /**
         * Apply a new dash space to the selected items
         *
         * @param items The items with stylable line properties
         * @param dash_space The space between dashes
         */
        private static void apply_dash_space(
            Gee.Iterable<Geda3.StylableLine> items,
            int dash_space
            )

            requires(items.all_match(i => i != null))
            requires(items.all_match(i => i.line_style != null))

        {
            foreach (var item in items)
            {
                item.line_style.dash_space = dash_space;
            }
        }


        /**
         * Apply a new dash type to the selected items
         *
         * @param items The items with stylable line properties
         * @param dash_type The dash type
         */
        private static void apply_dash_type(
            Gee.Iterable<Geda3.StylableLine> items,
            Geda3.DashType dash_type
            )

            requires(items.all_match(i => i != null))
            requires(items.all_match(i => i.line_style != null))

        {
            foreach (var item in items)
            {
                item.line_style.dash_type = dash_type;
            }
        }


        /**
         * Apply a new line width to the selected items
         *
         * @param items The items with stylable line properties
         * @param width The line width
         */
        private static void apply_line_width(
            Gee.Iterable<Geda3.StylableLine> items,
            int width
            )

            requires(items.all_match(i => i != null))
            requires(width > 0)

        {
            foreach (var item in items)
            {
                item.width = width;
            }
        }


        /**
         *
         *
         *
         */
        private static ValueState fetch_cap_type(
            Gee.Iterable<Geda3.StylableLine> items,
            out Geda3.CapType cap_type
            )

            requires(items.all_match(i => i != null))
            requires(items.all_match(i => i.line_style != null))

        {
            var state = ValueState.UNAVAILABLE;
            var temp_cap_type = Geda3.CapType.NONE;

            foreach (var item in items)
            {
                if (state == ValueState.UNAVAILABLE)
                {
                    temp_cap_type = item.line_style.cap_type;
                    state = ValueState.AVAILABLE;
                    continue;
                }

                if (state == ValueState.AVAILABLE)
                {
                    if (temp_cap_type != item.line_style.cap_type)
                    {
                        state = ValueState.INCONSISTENT;
                        break;
                    }
                }
            }

            cap_type = temp_cap_type;

            return state;
        }


        /**
         *
         */
        private static ValueState fetch_dash_length(
            Gee.Iterable<Geda3.StylableLine> items,
            out int dash_length
            )

            requires(items.all_match(i => i != null))
            requires(items.all_match(i => i.line_style != null))

        {
            var state = ValueState.UNAVAILABLE;
            var temp_dash_length = Geda3.DashType.DEFAULT_LENGTH;

            foreach (var item in items)
            {
                if (state == ValueState.UNAVAILABLE)
                {
                    temp_dash_length = item.line_style.dash_length;
                    state = ValueState.AVAILABLE;
                    continue;
                }

                if (state == ValueState.AVAILABLE)
                {
                    if (temp_dash_length != item.line_style.dash_length)
                    {
                        state = ValueState.INCONSISTENT;
                        break;
                    }
                }
            }

            dash_length = temp_dash_length;

            return state;
        }


        /**
         *
         */
        private static ValueState fetch_dash_space(
            Gee.Iterable<Geda3.StylableLine> items,
            out int dash_space
            )

            requires(items.all_match(i => i != null))
            requires(items.all_match(i => i.line_style != null))

        {
            var state = ValueState.UNAVAILABLE;
            var temp_dash_space = Geda3.DashType.DEFAULT_SPACE;

            foreach (var item in items)
            {
                if (state == ValueState.UNAVAILABLE)
                {
                    temp_dash_space = item.line_style.dash_space;
                    state = ValueState.AVAILABLE;
                    continue;
                }

                if (state == ValueState.AVAILABLE)
                {
                    if (temp_dash_space != item.line_style.dash_space)
                    {
                        state = ValueState.INCONSISTENT;
                        break;
                    }
                }
            }

            dash_space = temp_dash_space;

            return state;
        }


        /**
         *
         *
         *
         */
        private static ValueState fetch_dash_type(
            Gee.Iterable<Geda3.StylableLine> items,
            out Geda3.DashType dash_type
            )

            requires(items.all_match(i => i != null))
            requires(items.all_match(i => i.line_style != null))

        {
            var state = ValueState.UNAVAILABLE;
            var temp_dash_type = Geda3.DashType.SOLID;

            foreach (var item in items)
            {
                if (state == ValueState.UNAVAILABLE)
                {
                    temp_dash_type = item.line_style.dash_type;
                    state = ValueState.AVAILABLE;
                    continue;
                }

                if (state == ValueState.AVAILABLE)
                {
                    if (temp_dash_type != item.line_style.dash_type)
                    {
                        state = ValueState.INCONSISTENT;
                        break;
                    }
                }
            }

            dash_type = temp_dash_type;

            return state;
        }


        /**
         *
         */
        private static ValueState fetch_width(
            Gee.Iterable<Geda3.StylableLine> items,
            out int width
            )

            requires(items.all_match(i => i != null))

        {
            var state = ValueState.UNAVAILABLE;
            var temp_width = 10;

            foreach (var item in items)
            {
                if (state == ValueState.UNAVAILABLE)
                {
                    temp_width = item.width;
                    state = ValueState.AVAILABLE;
                    continue;
                }

                if (state == ValueState.AVAILABLE)
                {
                    if (temp_width != item.width)
                    {
                        state = ValueState.INCONSISTENT;
                        break;
                    }
                }
            }

            width = temp_width;

            return state;
        }


        /**
         *
         */
        private void on_apply_cap_type()

            requires(m_cap_type_combo != null)
            requires(m_items != null)

        {
            try
            {
                var cap_type = Geda3.CapType.parse(
                    m_cap_type_combo.active_id
                    );

                apply_cap_type(m_items, cap_type);
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         *
         */
        private void on_apply_dash_length()

            requires(m_dash_length_combo != null)
            requires(m_items != null)

        {
            try
            {
                var dash_length = Geda3.Coord.parse(
                    m_dash_length_combo.content
                    );

                apply_dash_length(m_items, dash_length);
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         *
         */
        private void on_apply_dash_space()

            requires(m_dash_space_combo != null)
            requires(m_items != null)

        {
            try
            {
                var dash_space = Geda3.Coord.parse(
                    m_dash_space_combo.content
                    );

                apply_dash_space(m_items, dash_space);
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         *
         */
        private void on_apply_dash_type()

            requires(m_dash_type_combo != null)
            requires(m_items != null)

        {
            try
            {
                var dash_type = Geda3.DashType.parse(
                    m_dash_type_combo.active_id
                    );

                apply_dash_type(m_items, dash_type);
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         *
         */
        private void on_apply_width()

            requires(m_items != null)
            requires(m_width_combo != null)

        {
            try
            {
                var width = Geda3.Coord.parse(m_width_combo.content);

                apply_line_width(m_items, width);
            }
            catch (Error error)
            {
                assert_not_reached();
            }
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
        private ulong[] m_apply_signal_ids;


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
        public void on_selection_change()
        {
            update();
        }


        /**
         *
         */
        private void update()
        {
            SignalHandler.block(m_cap_type_combo, m_apply_signal_ids[0]);
            SignalHandler.block(m_dash_length_combo, m_apply_signal_ids[1]);
            SignalHandler.block(m_dash_space_combo, m_apply_signal_ids[2]);
            SignalHandler.block(m_dash_type_combo, m_apply_signal_ids[3]);
            SignalHandler.block(m_width_combo, m_apply_signal_ids[4]);

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

            update_cap_type_combo(m_items);
            update_dash_type_combo(m_items);

            update_combo(m_items, fetch_dash_length, m_dash_length_combo);
            update_combo(m_items, fetch_dash_space, m_dash_space_combo);
            update_combo(m_items, fetch_width, m_width_combo);

            update_sensitivities(m_items);

            SignalHandler.unblock(m_cap_type_combo, m_apply_signal_ids[0]);
            SignalHandler.unblock(m_dash_length_combo, m_apply_signal_ids[1]);
            SignalHandler.unblock(m_dash_space_combo, m_apply_signal_ids[2]);
            SignalHandler.unblock(m_dash_type_combo, m_apply_signal_ids[3]);
            SignalHandler.unblock(m_width_combo, m_apply_signal_ids[4]);
        }


        /**
         * Update
         *
         * @param items
         */
        private void update_cap_type_combo(
            Gee.Iterable<Geda3.StylableLine> items
            )

            requires(m_cap_type_combo != null)

        {
            var type = Geda3.CapType.NONE;
            var state = fetch_cap_type(items, out type);

            m_cap_type_combo.sensitive = state.is_sensitive();

            if (state.is_available())
            {
                m_cap_type_combo.active_id = "%d".printf(type);
            }
            else
            {
                m_cap_type_combo.active = -1;
            }
        }


        /**
         * Update the integer value in a combo box
         *
         * @param items
         * @param fetcher
         * @param combo
         */
        private static void update_combo(
            Gee.Iterable<Geda3.StylableLine> items,
            Fetcher fetcher,
            PropertyComboBox combo
            )
        {
            int @value;

            var state = fetcher(items, out @value);

            if (state.is_available())
            {
                combo.content = @value.to_string();
            }
            else
            {
                combo.content = null;
            }
        }


        /**
         * Update
         *
         * @param items
         */
        private void update_dash_type_combo(
            Gee.Iterable<Geda3.StylableLine> items
            )

            requires(m_dash_type_combo != null)

        {
            var type = Geda3.DashType.SOLID;
            var state = fetch_dash_type(items, out type);

            m_dash_type_combo.sensitive = state.is_sensitive();

            if (state.is_available())
            {
                m_dash_type_combo.active_id = "%d".printf(type);
            }
            else
            {
                m_dash_type_combo.active = -1;
            }
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
