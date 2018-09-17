namespace Gschem3
{
    /**
     *
     */
    //[GtkTemplate(ui="/com/github/ehennes775/gschem3/ProjectWidget.ui.xml")]
    public class AttributeEditor : Gtk.Box, Gtk.Buildable
    {
        /**
         * The current window
         */
        public DocumentWindow? current_window
        {
            get
            {
                return b_current_window;
            }
            construct set
            {
                if (b_current_window != null)
                {
                }

                b_current_window = value as SchematicWindow;

                if (b_current_window != null)
                {
                }
            }
            default = null;
        }


        /**
         * The attribute parent being edited
         */
        public Geda3.SchematicItem? parent
        {
            get
            {
                return b_parent;
            }
            construct set
            {
                if (b_parent != null)
                {
                    b_parent.attached.disconnect(on_attached);
                    b_parent.detached.disconnect(on_detached);
                }

                b_parent = value as Geda3.AttributeParent;

                if (b_parent != null)
                {
                    b_parent.attached.connect(on_attached);
                    b_parent.detached.connect(on_detached);
                }
            }
            default = null;
        }


        /**
         * The backing store for the current window
         */
        private SchematicWindow? b_current_window;


        /**
         * The backing store for attribute parent being edited
         */
        private Geda3.AttributeParent? b_parent;


        /**
         * The backing store for attribute parent being edited
         */
        public void on_attached(Geda3.AttributeChild child, Geda3.AttributeParent parent)
        {
        }


        /**
         * The backing store for attribute parent being edited
         */
        public void on_detached(Geda3.AttributeChild child, Geda3.AttributeParent parent)
        {
        }
    }
}
