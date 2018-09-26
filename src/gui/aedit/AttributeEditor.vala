namespace Gschem3
{
    /**
     *
     */
    [GtkTemplate(ui="/com/github/ehennes775/gschem3/gui/aedit/AttributeEditor.ui.xml")]
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
         *
         */
        construct
        {
            m_name_renderer.edited.connect(on_item_edited);
            m_value_renderer.edited.connect(on_item_edited);
        }


        /**
         *
         */
        private enum Column
        {
            NAME,
            VALUE
        }


        /**
         * The backing store for the current item being edited
         */
        private Geda3.AttributeParent? b_item;


        /**
         *
         */
        [GtkChild(name="list")]
        private Gtk.ListStore m_list;


        /**
         *
         */
        [GtkChild(name="column-name-renderer-name")]
        private Gtk.CellRendererText m_name_renderer;


        /**
         *
         */
        [GtkChild(name="tree")]
        private Gtk.TreeView m_tree_view;


        /**
         *
         */
        [GtkChild(name="column-value-renderer-value")]
        private Gtk.CellRendererText m_value_renderer;


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


        /**
         *
         */
        private void on_item_edited(Gtk.CellRendererText sender, string path_string, string new_name)
        {
        }
    }
}
