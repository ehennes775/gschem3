namespace Gschem3
{
    /**
     *
     */
    public class DrawingTool : Object
    {
        /**
         *
         */
        public const string ArcName = "arc";


        /**
         *
         */
        public const string BoxName = "box";


        /**
         *
         */
        public const string BusName = "bus";


        /**
         *
         */
        public const string CircleName = "circle";


        /**
         *
         */
        public const string LineName = "line";


        /**
         *
         */
        public const string NetName = "net";


        /**
         *
         */
        public const string PathName = "path";


        /**
         *
         */
        public const string PinName = "pin";


        /**
         *
         */
        public const string SelectName = "select";


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
        public virtual bool button_released(Gdk.EventButton event)
        {
            stdout.printf("on_button_release_event\n");

            return false;
        }


        /**
         *
         *
         * @param next_file the file to read the schematic from
         */
        public virtual void cancel()
        {
            stdout.printf("cancel\n");
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
            //stdout.printf("on_motion_notify_event\n");

            return false;
        }


        /**
         *
         *
         * @param next_file the file to read the schematic from
         */
        public virtual void reset()
        {
            stdout.printf("reset\n");
        }
    }
}
