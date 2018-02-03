namespace Gschem3
{
    /**
     *
     */
    public class DrawingTool : Object
    {
        /**
         *
         *
         * @param next_file the file to read the schematic from
         */
        public virtual bool button_pressed(Gdk.EventButton event)
        {
            stdout.printf("on_button_press_event\n");

            return false;
        }


        /**
         *
         *
         * @param next_file the file to read the schematic from
         */
        public bool button_released(Gdk.EventButton event)
        {
            stdout.printf("on_button_release_event\n");

            return false;
        }


        /**
         *
         *
         * @param next_file the file to read the schematic from
         */
        public virtual bool key_pressed(Gdk.EventKey event)
        {
            stdout.printf("on_key_press_event\n");

            return false;
        }


        /**
         *
         *
         * @param next_file the file to read the schematic from
         */
        public virtual bool key_released(Gdk.EventKey event)
        {
            stdout.printf("on_key_release_event\n");

            return false;
        }


        /**
         *
         *
         * @param next_file the file to read the schematic from
         */
        public virtual bool motion_notify(Gdk.EventMotion event)
        {
            stdout.printf("on_motion_notify_event\n");

            return false;
        }
    }
}
