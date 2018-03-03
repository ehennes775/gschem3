namespace Geda3
{
    /**
     * The line style for graphic items
     *
     * Since the line style does not change the bounds of the object,
     * items can use the notify signal from these properties to
     * determine when to invalidate.
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
            construct set
            {
                return_if_fail(value >= 0);
                return_if_fail(value < CapType.COUNT);

                b_cap_type = value;
            }
            default = CapType.NONE;
        }


        /**
         * The length of dashes
         *
         * If the dash type does not require a length, this contains
         * the last used length or the default length. This value will
         * not assume a value of -1 for an unused length, as specified
         * in the file format.
         */
        public int dash_length
        {
            get
            {
                return b_dash_length;
            }
            construct set
            {
                return_if_fail(value >= 0);

                b_dash_length = value;
            }
            default = DashType.DEFAULT_LENGTH;
        }


        /**
         * The spacing between dashes
         *
         * If the dash type does not require a spacing, this contains
         * the last used spacing or the default spacing. This value
         * will not assume a value of -1 for an unused spacing, as
         * specified in the file format.
         */
        public int dash_space
        {
            get
            {
                return b_dash_space;
            }
            construct set
            {
                return_if_fail(value >= 0);

                b_dash_space = value;
            }
            default = DashType.DEFAULT_SPACE;
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
            construct set
            {
                return_if_fail(value >= 0);
                return_if_fail(value < DashType.COUNT);

                b_dash_type = value;
            }
            default = DashType.SOLID;
        }


        /**
         * Set the line style using parameters
         *
         * Uses parameters, as from an input file, to set the line
         * style. If an error occurs parsing the parameters, the line
         * style will remain unchanged.
         *
         * ||0||Cap type||
         * ||1||Dash type||
         * ||2||Dash length||
         * ||3||Dash Space||
         *
         * @param params The parameters
         * @throw ParseError A parameter was invalid
         */
        public void set_from_params(string[] params) throws ParseError

            requires(params.length == 4)

        {
            var temp_cap_type = CapType.parse(params[0]);
            var temp_dash_type = DashType.parse(params[1]);
            var temp_dash_length = temp_dash_type.parse_length(params[2]);
            var temp_dash_space = temp_dash_type.parse_space(params[3]);

            cap_type = temp_cap_type;
            dash_type = temp_dash_type;
            dash_length = temp_dash_length;
            dash_space = temp_dash_space;
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

