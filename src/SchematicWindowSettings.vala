namespace Gschem3
{
    /**
     * Settings shared by all schematic windows
     */
    public class SchematicWindowSettings : Object
    {
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
         *
         */
        public Geda3.ColorScheme scheme
        {
            get
            {
                return b_scheme;
            }
        }


        /**
         * Initialize the class
         */
        static construct
        {
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
         *
         */
        private SchematicWindowSettings()
        {
        }


        /**
         *
         */
        private static Grid s_default_grid = new NoGrid();


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
        private Geda3.ColorScheme b_scheme = new Geda3.ColorScheme.Dark();
    }
}
