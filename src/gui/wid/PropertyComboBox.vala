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
                var entry = get_child() as Gtk.Entry;

                return_val_if_fail(entry != null, null);

                entry.text = value ?? "";
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
         */
        protected delegate bool CompareValueFunc(Value val);


        /**
         *
         *
         * @param column
         * @param val
         */
        protected bool get_active_value(
            int column,
            out Value val
            )

            requires(model != null)

        {
            Gtk.TreeIter iter;

            var success = get_active_iter(out iter);

            if (success)
            {
                model.get_value(
                    iter,
                    column,
                    out val
                    );
            }

            return success;
        }


        /**
         * Set the active row using a value
         *
         * @param column The index of the column containing the value
         * @param compare A delegate returning true when the matching
         * row is found
         * @return Returns true if a row was found
         */
        protected bool set_active_by_value(
            int column,
            CompareValueFunc compare
            )

            requires(model != null)

        {
            Gtk.TreeIter iter;

            var success = model.get_iter_first(out iter);

            while (success)
            {
                Value val;

                model.get_value(
                    iter,
                    column,
                    out val
                    );

                if (compare(val))
                {
                    set_active_iter(iter);

                    break;
                }

                success = model.iter_next(ref iter);
            }

            return success;
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
