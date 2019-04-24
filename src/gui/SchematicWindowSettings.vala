namespace Gschem3
{
    /**
     * Settings shared by all schematic windows
     */
    public class SchematicWindowSettings : Object
    {
        /**
         * A signal indicating the color scheme has changed
         *
         * This signal provides a parameter for the sinks, so that they
         * don't need to maintain a reference to the color scheme, and
         * can simply perform an update when the signal is received.
         *
         * @param scheme The new color scheme
         */
        public signal void color_scheme_changed(
            Geda3.ColorScheme scheme
            );


        /**
         *
         */
        public Grid grid
        {
            get
            {
                return b_grid;
            }
            set
            {
                b_grid = value ?? s_default_grid;
            }
        }


        /**
         * Show hidden objects in all schematic windows
         */
        public bool reveal
        {
            get;
            set;
            default = false;
        }


        /**
         *
         */
        public Geda3.ColorScheme scheme
        {
            get
            {
                return b_scheme;
            }
            set
            {
                if (b_scheme != null)
                {
                    b_scheme.color_scheme_changed.disconnect(
                        on_color_scheme_changed
                        );
                }

                b_scheme = value;

                if (b_scheme != null)
                {
                    b_scheme.color_scheme_changed.connect(
                        on_color_scheme_changed
                        );
                }
            }
            default = new Geda3.ColorScheme.Dark();
        }


        /**
         * Initialize the class
         */
        static construct
        {
            s_grids = new Gee.HashMap<string,Grid>();

            s_grids.@set("none", new NoGrid());
            s_grids.@set("mesh", new MeshGrid());

            s_default_grid = s_grids["mesh"];
        }


        /**
         * Initialize the instance
         */
        construct
        {
            grid = s_default_grid; 
        }


        /**
         * Get the default instance
         */
        public static SchematicWindowSettings get_default()
        {
            if (s_instance == null)
            {
                s_instance = new SchematicWindowSettings();
            }
            
            return s_instance;
        }


        /**
         * Select a grid using the name
         *
         * If no grid exists with the given name, this function will
         * fail a precondition and the grid will remain unchanged.
         *
         * @param name The name of the grid
         */
        public void set_grid_by_name(string name)

            requires(s_grids != null)
            requires(s_grids.has_key(name))

        {
            var temp_grid = s_grids[name];

            return_if_fail(temp_grid != null);

            grid = temp_grid;
        }


        /**
         *
         */
        private SchematicWindowSettings()
        {
        }


        /**
         *
         */
        private static Grid s_default_grid;


        /**
         *
         */
        private static Gee.HashMap<string,Grid> s_grids;


        /**
         * Backing store for the default instance
         */
        private static SchematicWindowSettings s_instance = null;


        /**
         * Backing store for the grid property
         */
        private Grid b_grid;


        /**
         * The color scheme used for all schematic windows
         */
        private Geda3.ColorScheme b_scheme;


        /**
         * Event handler for when the color scheme changes
         *
         * @param scheme The new color scheme
         */
        public void on_color_scheme_changed(Geda3.ColorScheme scheme)
        {
            color_scheme_changed(scheme);
        }
    }
}
