namespace Gschem3
{
    /**
     *
     */
    public class PropertyComboBox : Gtk.ComboBox, Gtk.Buildable
    {
        /**
         *
         */
        public signal void apply();


        /**
         *
         */
        public string? content
        {
            get
            {
                var entry = get_child() as Gtk.Entry;

                return_val_if_fail(entry != null, null);

                return entry.text;
            }
            set
            {
            }
        }


        /**
         *
         */
        construct
        {
            add.connect(on_add);
            changed.connect(on_changed);
            notify["active"].connect(on_notify_active);
            remove.connect(on_remove);
        }


        /**
         *
         *
         * @param widget
         */
        private bool m_changed;


        /**
         *
         *
         * @param widget
         */
        private void on_add(Gtk.Widget widget)
        {
            widget.focus_out_event.connect(
                on_focus_out_event
                );

            var window = widget.get_window();

            return_if_fail(window != null);

            window.set_events(
                window.get_events() | Gdk.EventMask.FOCUS_CHANGE_MASK
                );
        }


        /**
         *
         *
         * @param widget
         */
        private void on_remove(Gtk.Widget widget)
        {
            stdout.printf("PropertyComboBox.remove\n");

            widget.focus_out_event.disconnect(
                on_focus_out_event
                );
        }


        /**
         *
         *
         * @param event
         */
        private void on_changed()
        {
            m_changed = true;
        }


        /**
         *
         *
         * @param event
         */
        private bool on_focus_out_event(Gdk.EventFocus event)
        {
            if (m_changed)
            {
                apply();

                m_changed = false;
            }

            return false;
        }


        /**
         *
         *
         * @param event
         */
        private void on_notify_active(ParamSpec param)
        {
            apply();

            m_changed = false;
        }
    }
}
