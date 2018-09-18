namespace Gschem3
{
    /**
     *
     */
    //[GtkTemplate(ui="/com/github/ehennes775/gschem3/ProjectWidget.ui.xml")]
    public class AttributeEditor : Gtk.Box, Gtk.Buildable
    {
        /**
         * The current item being edited
         */
        public Geda3.SchematicItem? item
        {
            get
            {
                return b_item;
            }
            construct set
            {
                if (b_item != null)
                {
                    b_item.attached.disconnect(on_attached);
                    b_item.detached.disconnect(on_detached);
                }

                b_item = value as Geda3.AttributeParent;

                if (b_item != null)
                {
                    b_item.attached.connect(on_attached);
                    b_item.detached.connect(on_detached);
                }
            }
            default = null;
        }


        /**
         * The backing store for the current item being edited
         */
        private Geda3.AttributeParent? b_item;


        /**
         *
         */
        private void on_attached(Geda3.AttributeChild child, Geda3.AttributeParent parent)
        {
        }


        /**
         *
         */
        private void on_detached(Geda3.AttributeChild child, Geda3.AttributeParent parent)
        {
        }
    }
}
