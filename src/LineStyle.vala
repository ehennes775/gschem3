namespace Geda3
{
    /**
     * The line style for graphic items
     *
     * Since the line style does not change the bounds of the object,
     * items can use the notify signal to determine when to invalidate.
     */
    public class LineStyle : Object
    {
        /**
         * The cap type
         */
        public CapType cap_type
        {
            get
            {
                return b_cap_type;
            }
            set
            {
                return_if_fail(value >= 0);
                return_if_fail(value < CapType.COUNT);

                b_cap_type = value;
            }
            default = CapType.NONE;
        }


        /**
         * The length of dashes
         */
        public int dash_length
        {
            get
            {
                return b_dash_length;
            }
            set
            {
                //return_if_fail(value >= 0);

                b_dash_length = value;
            }
            // fails to initiaize here with custom getter and setter
            // default = DashType.DEFAULT_LENGTH;
        }


        /**
         * The spacing between dashes
         */
        public int dash_space
        {
            get
            {
                return b_dash_space;
            }
            set
            {
                return_if_fail(value >= 0);

                b_dash_space = value;
            }
            // fails to initiaize here with custom getter and setter
            // default = DashType.DEFAULT_SPACE;
        }


        /**
         * The type of dashed line
         */
        public DashType dash_type
        {
            get
            {
                return b_dash_type;
            }
            set
            {
                return_if_fail(value >= 0);
                return_if_fail(value < DashType.COUNT);

                b_dash_type = value;
            }
            default = DashType.SOLID;
        }


        construct
        {
            //cap_type = CapType.NONE;
            dash_length = DashType.DEFAULT_LENGTH;
            dash_space = DashType.DEFAULT_SPACE;
            //dash_type = DashType.SOLID;
        }


        /**
         * Backing store for the cap type
         */
        private CapType b_cap_type;


        /**
         * Backing store for the dash length
         */
        private int b_dash_length;


        /**
         * Backing store for the dash space
         */
        private int b_dash_space;


        /**
         * Backing store for the dash type
         */
        private DashType b_dash_type;
    }
}

