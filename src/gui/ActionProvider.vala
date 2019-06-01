namespace Gschem3
{
    /**
     *
     */
    public interface ActionProvider : Gtk.Widget
    {
        /**
         *
         */
        public abstract void add_actions_to(ActionMap map);
    }
}
