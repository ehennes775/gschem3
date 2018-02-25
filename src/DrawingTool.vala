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
         [CCode(has_target=false)]
        protected delegate bool KeyFunction(DrawingTool tool, Gdk.EventKey event);


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


        public DrawingTool(SchematicWindow window)
        {
            m_window = window;

            m_key_map = new Gee.HashMap<uint,KeyFunction>();

            m_key_map.@set(Gdk.Key.z, key_zoom_in);
            m_key_map.@set(Gdk.Key.Z, key_zoom_out);
        }


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
        public virtual void draw(Geda3.SchematicPainterCairo context)
        {
        }


        /**
         *
         *
         * @param next_file the file to read the schematic from
         */
        public virtual bool key_pressed(Gdk.EventKey event)
        {
            stdout.printf("on_key_press_event\n");

            uint keyval;

            if (event.get_keyval(out keyval))
            {
                if (m_key_map.has_key(keyval))
                {
                    var function = m_key_map[keyval];

                    return function(this, event);
                }
            }

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

            m_x = (int) Math.round(event.x);
            m_y = (int) Math.round(event.y);

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


        /**
         *
         */
        protected Gee.Map<uint,KeyFunction> m_key_map;


        /**
         * The document window this tool is drawing into
         */
        protected weak SchematicWindow m_window;


        /**
         *
         */
        protected static bool key_zoom_in(DrawingTool tool, Gdk.EventKey event)

            requires(tool.m_window != null)

        {
            tool.m_window.zoom_in_point(tool.m_x, tool.m_y);

            return true;
        }


        /**
         *
         */
        protected static bool key_zoom_out(DrawingTool tool, Gdk.EventKey event)

            requires(tool.m_window != null)

        {
            tool.m_window.zoom_out_point(tool.m_x, tool.m_y);

            return true;
        }


        private int m_x;
        private int m_y;
    }
}
