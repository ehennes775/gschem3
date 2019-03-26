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
        public signal void request_cancel();

        
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
        public const string ComplexName = "complex";


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
        public const string SELECT_NAME = "select";


        /**
         *
         */
        public const string ZOOM_NAME = "zoom";


        public DrawingTool(SchematicWindow? window)
        {
            m_window = window;

            m_key_map = new Gee.HashMap<uint,KeyFunction>();

            m_key_map.@set(Gdk.Key.Escape, key_cancel);

            m_key_map.@set(Gdk.Key.Left, key_pan_left);
            m_key_map.@set(Gdk.Key.Right, key_pan_right);
            m_key_map.@set(Gdk.Key.Up, key_pan_up);
            m_key_map.@set(Gdk.Key.Down, key_pan_down);

            m_key_map.@set(Gdk.Key.x, key_pan);
            m_key_map.@set(Gdk.Key.z, key_zoom_in);
            m_key_map.@set(Gdk.Key.Z, key_zoom_out);
            m_key_map.@set(Gdk.Key.w, key_zoom_tool);
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
         * Process a key pressed event
         *
         * @param event The key released event to process
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
         * Process a key released event
         *
         * @param event The key released event to process
         */
        public virtual bool key_released(Gdk.EventKey event)
        {
            stdout.printf("on_key_release_event\n");

            return false;
        }


        /**
         * Process a mouse motion event
         *
         * Overridden methods must chain up to the base method.
         *
         * @param event The mouse motion event to process
         */
        public virtual bool motion_notify(Gdk.EventMotion event)
        {
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
        public virtual void reset_with_point(double x, double y)
        {
            stdout.printf("reset_with_point\n");
        }


        /**
         * Set the current document window for this tool
         *
         * @param window The document window
         */
        public void update_document_window(DocumentWindow? window)
        {
            if(m_window != null)
            {
            }

            m_window = window as SchematicWindow;

            if(m_window != null)
            {
            }
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
        protected static bool key_cancel(DrawingTool tool, Gdk.EventKey event)

            requires(tool.m_window != null)

        {
            tool.request_cancel();

            return true;
        }


        /**
         *
         */
        protected static bool key_pan(DrawingTool tool, Gdk.EventKey event)

            requires(tool.m_window != null)

        {
            tool.m_window.pan_point(tool.m_x, tool.m_y);

            return true;
        }


        /**
         *
         */
        protected static bool key_pan_down(DrawingTool tool, Gdk.EventKey event)

            requires(tool.m_window != null)

        {
            tool.m_window.pan_delta(0, -1);

            return true;
        }


        /**
         *
         */
        protected static bool key_pan_left(DrawingTool tool, Gdk.EventKey event)

            requires(tool.m_window != null)

        {
            tool.m_window.pan_delta(1, 0);

            return true;
        }


        /**
         *
         */
        protected static bool key_pan_right(DrawingTool tool, Gdk.EventKey event)

            requires(tool.m_window != null)

        {
            tool.m_window.pan_delta(-1, 0);

            return true;
        }


        /**
         *
         */
        protected static bool key_pan_up(DrawingTool tool, Gdk.EventKey event)

            requires(tool.m_window != null)

        {
            tool.m_window.pan_delta(0, 1);

            return true;
        }


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


        /**
         *
         */
        protected static bool key_zoom_tool(DrawingTool tool, Gdk.EventKey event)

            requires(tool.m_window != null)

        {
            //tool.m_window.select_tool_with_point(
            //    ZOOM_NAME,
            //    tool.m_x,
            //    tool.m_y
            //    );
            // 
            //return true;

            return false;
        }


        private int m_x;
        private int m_y;
    }
}
