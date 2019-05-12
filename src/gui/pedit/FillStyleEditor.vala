namespace Gschem3
{
    /**
     *
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/pedit/FillStyleEditor.ui.xml")]
    public class FillStyleEditor : Gtk.Expander, ItemEditor
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
         *
         */
        static construct
        {
            stdout.printf("%s\n",typeof(FillSwatchRenderer).name());
            stdout.printf("%s\n",typeof(PropertyComboBox).name());
        }



        /**
         *
         */
        construct
        {
            expanded = true;                // not getting set in the XML
            label = "<b>Fill Style</b>";    // not getting set in the XML
            margin_bottom = 8;              // not getting set in the XML
            margin_top = 8;                 // not getting set in the XML
            use_markup = true;              // not getting set in the XML

            m_apply_signal_ids = new ulong[]
            {
                m_angle_combo_1.apply.connect(on_apply_angle_1),
                m_angle_combo_2.apply.connect(on_apply_angle_2),
                m_pitch_combo_1.apply.connect(on_apply_pitch_1),
                m_pitch_combo_2.apply.connect(on_apply_pitch_2),
                m_width_combo.apply.connect(on_apply_width)
            };

            m_type_signal_id = m_type_combo.apply.connect(on_apply_fill_type);

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
         * A delegate for applying a fill style
         */
        private delegate void FillStyleApplicator(
            Geda3.FillStyle style
            );


        /**
         *
         */
        [CCode(has_target=false)]
        private delegate ValueState Fetcher(Gee.Iterable<Geda3.Fillable> items, out int @value);


        /**
         * The backing store for the schematic window property
         */
        private SchematicWindow? b_schematic_window;


        /**
         *
         */
        [GtkChild(name="fill-angle-1-combo")]
        private PropertyComboBox m_angle_combo_1;


        /**
         *
         */
        [GtkChild(name="fill-angle-1-entry")]
        private Gtk.Entry m_angle_entry_1;


        /**
         *
         */
        [GtkChild(name="fill-angle-2-combo")]
        private PropertyComboBox m_angle_combo_2;


        /**
         *
         */
        [GtkChild(name="fill-angle-2-entry")]
        private Gtk.Entry m_angle_entry_2;


        /**
         *
         */
        private ulong[] m_apply_signal_ids;


        /**
         *
         */
        private Gee.List<Geda3.Fillable> m_items = new Gee.ArrayList<Geda3.Fillable>();


        /**
         *
         */
        [GtkChild(name="fill-pitch-1-combo")]
        private PropertyComboBox m_pitch_combo_1;


        /**
         *
         */
        [GtkChild(name="fill-pitch-1-entry")]
        private Gtk.Entry m_pitch_entry_1;


        /**
         *
         */
        [GtkChild(name="fill-pitch-2-combo")]
        private PropertyComboBox m_pitch_combo_2;


        /**
         *
         */
        [GtkChild(name="fill-pitch-2-entry")]
        private Gtk.Entry m_pitch_entry_2;


        /**
         *
         */
        [GtkChild(name="fill-type-combo")]
        private PropertyComboBox m_type_combo;


        /**
         *
         */
        private ulong m_type_signal_id;


        /**
         *
         */
        [GtkChild(name="line-width-combo")]
        private PropertyComboBox m_width_combo;


        /**
         * Apply a fill style to the selection
         *
         * @param applicator A delegate to apply the new style
         */
        private void apply_fill_style(FillStyleApplicator applicator)

            requires(m_items != null)
            requires(m_items.all_match((i) => i != null))
            requires(m_items.all_match((i) => i.fill_style != null))

        {
            foreach (var item in m_items)
            {
                applicator(item.fill_style);
            }
        }


        /**
         *
         */
        private static ValueState fetch_angle_1(Gee.Iterable<Geda3.Fillable> items, out int angle)
        {
            var state = ValueState.UNAVAILABLE;
            var temp_angle = Geda3.FillStyle.DEFAULT_ANGLE_1;

            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                if (item.fill_style == null)
                {
                    warn_if_reached();
                    continue;
                }

                if (state == ValueState.UNAVAILABLE)
                {
                    temp_angle = item.fill_style.fill_angle_1;
                    state = ValueState.AVAILABLE;
                    continue;
                }

                if (state == ValueState.AVAILABLE)
                {
                    if (temp_angle != item.fill_style.fill_angle_1)
                    {
                        state = ValueState.INCONSISTENT;
                        break;
                    }
                }
            }

            angle = temp_angle;

            return state;
        }


        /**
         *
         */
        private static ValueState fetch_angle_2(Gee.Iterable<Geda3.Fillable> items, out int angle)
        {
            var state = ValueState.UNAVAILABLE;
            var temp_angle = Geda3.FillStyle.DEFAULT_ANGLE_2;

            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                if (item.fill_style == null)
                {
                    warn_if_reached();
                    continue;
                }

                if (state == ValueState.UNAVAILABLE)
                {
                    temp_angle = item.fill_style.fill_angle_2;
                    state = ValueState.AVAILABLE;
                    continue;
                }

                if (state == ValueState.AVAILABLE)
                {
                    if (temp_angle != item.fill_style.fill_angle_2)
                    {
                        state = ValueState.INCONSISTENT;
                        break;
                    }
                }
            }

            angle = temp_angle;

            return state;
        }


        /**
         *
         */
        private static ValueState fetch_pitch_1(Gee.Iterable<Geda3.Fillable> items, out int pitch)
        {
            var state = ValueState.UNAVAILABLE;
            var temp_pitch = Geda3.FillStyle.DEFAULT_PITCH_1;

            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                if (item.fill_style == null)
                {
                    warn_if_reached();
                    continue;
                }

                if (state == ValueState.UNAVAILABLE)
                {
                    temp_pitch = item.fill_style.fill_pitch_1;
                    state = ValueState.AVAILABLE;
                    continue;
                }

                if (state == ValueState.AVAILABLE)
                {
                    if (temp_pitch != item.fill_style.fill_pitch_1)
                    {
                        state = ValueState.INCONSISTENT;
                        break;
                    }
                }
            }

            pitch = temp_pitch;

            return state;
        }


        /**
         *
         */
        private static ValueState fetch_pitch_2(Gee.Iterable<Geda3.Fillable> items, out int pitch)
        {
            var state = ValueState.UNAVAILABLE;
            var temp_pitch = Geda3.FillStyle.DEFAULT_PITCH_2;

            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                if (item.fill_style == null)
                {
                    warn_if_reached();
                    continue;
                }

                if (state == ValueState.UNAVAILABLE)
                {
                    temp_pitch = item.fill_style.fill_pitch_2;
                    state = ValueState.AVAILABLE;
                    continue;
                }

                if (state == ValueState.AVAILABLE)
                {
                    if (temp_pitch != item.fill_style.fill_pitch_2)
                    {
                        state = ValueState.INCONSISTENT;
                        break;
                    }
                }
            }

            pitch = temp_pitch;

            return state;
        }


        /**
         *
         */
        private static ValueState fetch_type(Gee.Iterable<Geda3.Fillable> items, out Geda3.FillType type)
        {
            var state = ValueState.UNAVAILABLE;
            var temp_type = Geda3.FillType.HOLLOW;

            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                if (item.fill_style == null)
                {
                    warn_if_reached();
                    continue;
                }

                if (state == ValueState.UNAVAILABLE)
                {
                    temp_type = item.fill_style.fill_type;
                    state = ValueState.AVAILABLE;
                    continue;
                }

                if (state == ValueState.AVAILABLE)
                {
                    if (temp_type != item.fill_style.fill_type)
                    {
                        state = ValueState.INCONSISTENT;
                        break;
                    }
                }
            }

            type = temp_type;

            return state;
        }


        /**
         *
         */
        private static ValueState fetch_width(Gee.Iterable<Geda3.Fillable> items, out int width)
        {
            var state = ValueState.UNAVAILABLE;
            var temp_width = Geda3.FillStyle.DEFAULT_WIDTH;

            foreach (var item in items)
            {
                if (item == null)
                {
                    warn_if_reached();
                    continue;
                }

                if (item.fill_style == null)
                {
                    warn_if_reached();
                    continue;
                }

                if (state == ValueState.UNAVAILABLE)
                {
                    temp_width = item.fill_style.fill_width;
                    state = ValueState.AVAILABLE;
                    continue;
                }

                if (state == ValueState.AVAILABLE)
                {
                    if (temp_width != item.fill_style.fill_width)
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
        private void on_apply_angle_1()

            requires(m_angle_combo_1 != null)
            requires(m_items != null)

        {
            try
            {
                var angle = Geda3.Angle.parse(m_angle_combo_1.content);

                apply_fill_style(
                    (style) => { style.fill_angle_1 = angle; }
                    );
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         *
         */
        private void on_apply_angle_2()

            requires(m_angle_combo_2 != null)
            requires(m_items != null)

        {
            try
            {
                var angle = Geda3.Angle.parse(m_angle_combo_2.content);

                apply_fill_style(
                    (style) => { style.fill_angle_2 = angle; }
                    );
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         *
         */
        private void on_apply_fill_type()

            requires(m_items != null)
            requires(m_type_combo != null)

        {
            try
            {
                var fill_type = Geda3.FillType.parse(
                    m_type_combo.active_id
                    );

                apply_fill_style(
                    (style) => { style.fill_type = fill_type; }
                    );
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         *
         */
        private void on_apply_pitch_1()

            requires(m_items != null)
            requires(m_pitch_combo_1 != null)

        {
            try
            {
                var pitch = Geda3.Coord.parse(m_pitch_combo_1.content);

                apply_fill_style(
                    (style) => { style.fill_pitch_1 = pitch; }
                    );
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         *
         */
        private void on_apply_pitch_2()

            requires(m_items != null)
            requires(m_pitch_combo_2 != null)

        {
            try
            {
                var pitch = Geda3.Coord.parse(m_pitch_combo_2.content);

                apply_fill_style(
                    (style) => { style.fill_pitch_2 = pitch; }
                    );
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

                apply_fill_style(
                    (style) => { style.fill_width = width; }
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
        public void on_notify_schematic_window(ParamSpec param)
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

            requires(m_angle_combo_1 != null)
            requires(m_apply_signal_ids != null)

        {
            SignalHandler.block(m_angle_combo_1, m_apply_signal_ids[0]);
            SignalHandler.block(m_angle_combo_2, m_apply_signal_ids[1]);
            SignalHandler.block(m_pitch_combo_1, m_apply_signal_ids[2]);
            SignalHandler.block(m_pitch_combo_2, m_apply_signal_ids[3]);
            SignalHandler.block(m_width_combo, m_apply_signal_ids[4]);

            m_items.clear();

            if ((b_schematic_window != null) && (b_schematic_window.selection != null))
            {
                foreach (var item in b_schematic_window.selection)
                {
                    var fillable = item as Geda3.Fillable;

                    if (fillable == null)
                    {
                        continue;
                    }

                    m_items.add(fillable);
                }
            }

            update_fill_type_combo(m_items);
            update_combo(m_items, fetch_angle_1, m_angle_combo_1);
            update_combo(m_items, fetch_angle_2, m_angle_combo_2);
            update_combo(m_items, fetch_pitch_1, m_pitch_combo_1);
            update_combo(m_items, fetch_pitch_2, m_pitch_combo_2);
            update_combo(m_items, fetch_width, m_width_combo);
            update_sensitivities(m_items);

            SignalHandler.unblock(m_angle_combo_1, m_apply_signal_ids[0]);
            SignalHandler.unblock(m_angle_combo_2, m_apply_signal_ids[1]);
            SignalHandler.unblock(m_pitch_combo_1, m_apply_signal_ids[2]);
            SignalHandler.unblock(m_pitch_combo_2, m_apply_signal_ids[3]);
            SignalHandler.unblock(m_width_combo, m_apply_signal_ids[4]);
        }



        /**
         * Update the fill type combo box
         *
         * @param items Items in the selection implementing Fillable
         */
        private void update_fill_type_combo(Gee.Iterable<Geda3.Fillable> items)

            requires(m_type_combo != null)

        {
            var type = Geda3.FillType.HOLLOW;
            var state = fetch_type(items, out type);

            m_type_combo.sensitive = state.is_sensitive();

            SignalHandler.block(m_type_combo, m_type_signal_id);

            if (state.is_available())
            {
                m_type_combo.active_id = "%d".printf(type);
            }
            else
            {
                m_type_combo.active = -1;
            }

            SignalHandler.unblock(m_type_combo, m_type_signal_id);
        }


        /**
         * Update the integer value in a combo box
         *
         * @param items Items in the selection implementing Fillable
         * @param fetcher
         * @param combo
         */
        private static void update_combo(
            Gee.Iterable<Geda3.Fillable> items,
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
         * Update sensitivities for combo boxes
         *
         * @param items Items in the selection implementing Fillable
         */
        private void update_sensitivities(Gee.Iterable<Geda3.Fillable> items)

            requires(m_angle_combo_1 != null)
            requires(m_angle_combo_2 != null)
            requires(m_pitch_combo_1 != null)
            requires(m_pitch_combo_2 != null)
            requires(m_width_combo != null)

        {
            var sensitive_1 = items.any_match(
                item => item.fill_style.fill_type.uses_first_set()
                );

            var sensitive_2 = items.any_match(
                item => item.fill_style.fill_type.uses_second_set()
                );

            m_width_combo.sensitive = sensitive_1 || sensitive_2;

            m_angle_combo_1.sensitive = sensitive_1;
            m_pitch_combo_1.sensitive = sensitive_1;

            m_angle_combo_2.sensitive = sensitive_2;
            m_pitch_combo_2.sensitive = sensitive_2;
        }
    }
}
