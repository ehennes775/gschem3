namespace Gschem3
{
    /**
     *
     */
    public class EditItemAction : CustomAction
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
         * The main window
         */
        public MainWindow main_window
        {
            get
            {
                return b_main_window;
            }
            construct set
            {
                if (b_main_window != null)
                {
                    b_main_window.notify["document-window"].disconnect(
                        on_notify_document_window
                        );
                }

                b_main_window = value;

                if (b_main_window != null)
                {
                    b_main_window.notify["document-window"].connect(
                        on_notify_document_window
                        );

                    schematic_window =
                        main_window.document_window as SchematicWindow;
                }
                else
                {
                    schematic_window = null;
                }
            }
            default = null;
        }


        /**
         * Initialize the instance
         *
         * @param parent The parent window for dialog boxes
         */
        public EditItemAction(MainWindow parent)
        {
            main_window = parent;

            m_action = new SimpleAction(
                "edit-item",
                null
                );

            m_action.activate.connect(activate);
            m_action.set_enabled(false);

            action = m_action;

            m_item = null;
        }


        /**
         * Perform the operation
         *
         * @param parameter Unused
         */
        public void activate(Variant? parameter)

            requires(m_item != null)

        {
            var dialog = new TextEditorDialog();

            try
            {
                dialog.item = m_item;
                dialog.set_transient_for(b_main_window);

                var result = dialog.run();

                if (result == Gtk.ResponseType.OK)
                {
                }
            }
            catch (Error error)
            {
                assert_not_reached();
            }
            finally
            {
                if (dialog != null)
                {
                    dialog.destroy();
                }
            }
        }


        /**
         * The backing store for the schematic window property
         */
        private SchematicWindow? b_schematic_window;


        /**
         * The main window
         */
        private MainWindow b_main_window;


        /**
         *
         */
        private SimpleAction m_action;


        /**
         *
         */
        private Geda3.TextItem? m_item;


        /**
         *
         */
        private void on_notify_document_window(ParamSpec param)

            requires(b_main_window != null)

        {
            schematic_window =
                b_main_window.document_window as SchematicWindow;
        }


        /**
         *
         */
        private void on_selection_change()
        {
            m_item = null;

            if ((b_schematic_window != null) && (b_schematic_window.selection != null))
            {
                foreach (var item in b_schematic_window.selection)
                {
                    var temp = item as Geda3.TextItem;

                    if (temp == null)
                    {
                        continue;
                    }

                    if (m_item != null)
                    {
                        m_item = null;

                        break;
                    }

                    m_item = temp;
                }

                m_action.set_enabled(m_item != null);
            }
        }
    }
}
