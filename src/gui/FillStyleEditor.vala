namespace Gschem3
{
    /**
     *
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/FillStyleEditor.ui.xml")]
    public class FillStyleEditor : Gtk.Expander, ItemEditor
    {

        /**
         *
         */
        static construct
        {
            stdout.printf("%s\n",typeof(FillSwatchRenderer).name());
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

            m_angle_combo_1.changed.connect(on_changed_angle_1);
            m_angle_entry_1.activate.connect(on_activate_angle_1);

            m_angle_combo_2.changed.connect(on_changed_angle_2);
            m_angle_entry_2.activate.connect(on_activate_angle_2);

            m_pitch_combo_1.changed.connect(on_changed_pitch_1);
            m_pitch_entry_1.activate.connect(on_activate_pitch_1);

            m_pitch_combo_2.changed.connect(on_changed_pitch_2);
            m_pitch_entry_2.activate.connect(on_activate_pitch_2);

            m_width_combo.changed.connect(on_changed_width);
            m_width_entry.activate.connect(on_activate_width);

            m_type_combo.changed.connect(on_changed_fill_type);
        }


        /**
         *
         */
        [GtkChild(name="fill-angle-1-combo")]
        private Gtk.ComboBox m_angle_combo_1;


        /**
         *
         */
        [GtkChild(name="fill-angle-1-entry")]
        private Gtk.Entry m_angle_entry_1;


        /**
         *
         */
        [GtkChild(name="fill-angle-2-combo")]
        private Gtk.ComboBox m_angle_combo_2;


        /**
         *
         */
        [GtkChild(name="fill-angle-2-entry")]
        private Gtk.Entry m_angle_entry_2;


        /**
         *
         */
        [GtkChild(name="fill-pitch-1-combo")]
        private Gtk.ComboBox m_pitch_combo_1;


        /**
         *
         */
        [GtkChild(name="fill-pitch-1-entry")]
        private Gtk.Entry m_pitch_entry_1;


        /**
         *
         */
        [GtkChild(name="fill-pitch-2-combo")]
        private Gtk.ComboBox m_pitch_combo_2;


        /**
         *
         */
        [GtkChild(name="fill-pitch-2-entry")]
        private Gtk.Entry m_pitch_entry_2;


        /**
         *
         */
        [GtkChild(name="fill-type-combo")]
        private Gtk.ComboBox m_type_combo;


        /**
         *
         */
        [GtkChild(name="line-width-combo")]
        private Gtk.ComboBox m_width_combo;


        /**
         *
         */
        [GtkChild(name="line-width-entry")]
        private Gtk.Entry m_width_entry;


        /**
         *
         */
        private void on_activate_angle_1()
        {
            stdout.printf("on_activate_angle_1()\n");
        }


        /**
         *
         */
        private void on_activate_angle_2()
        {
            stdout.printf("on_activate_angle_2()\n");
        }


        /**
         *
         */
        private void on_activate_pitch_1()
        {
            stdout.printf("on_activate_pitch_1()\n");
        }


        /**
         *
         */
        private void on_activate_pitch_2()
        {
            stdout.printf("on_activate_pitch_2()\n");
        }


        /**
         *
         */
        private void on_activate_width()
        {
            stdout.printf("on_activate_width()\n");
        }


        /**
         *
         */
        private void on_changed_angle_1()
        {
            stdout.printf("on_changed_angle_1()\n");
        }


        /**
         *
         */
        private void on_changed_angle_2()
        {
            stdout.printf("on_changed_angle_2()\n");
        }


        /**
         *
         */
        private void on_changed_pitch_1()
        {
            stdout.printf("on_changed_pitch_1()\n");
        }


        /**
         *
         */
        private void on_changed_pitch_2()
        {
            stdout.printf("on_changed_pitch_2()\n");
        }


        /**
         *
         */
        private void on_changed_fill_type()

            requires(m_angle_combo_1 != null)
            requires(m_angle_combo_2 != null)
            requires(m_pitch_combo_1 != null)
            requires(m_pitch_combo_2 != null)
            requires(m_type_combo != null)
            requires(m_width_combo != null)

        {
            try
            {
                var fill_type = Geda3.FillType.parse(m_type_combo.active_id);

                m_width_combo.sensitive = fill_type.uses_first_set();

                m_angle_combo_1.sensitive = fill_type.uses_first_set();
                m_pitch_combo_1.sensitive = fill_type.uses_first_set();

                m_angle_combo_2.sensitive = fill_type.uses_second_set();
                m_pitch_combo_2.sensitive = fill_type.uses_second_set();
            }
            catch (Error error)
            {
                assert_not_reached();
            }
        }


        /**
         *
         */
        private void on_changed_width()
        {
            stdout.printf("on_changed_width()\n");
        }
    }
}
