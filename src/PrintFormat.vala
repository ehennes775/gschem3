namespace Geda3
{
    /**
     * Stores the page format for printing
     */
    public class PrintFormat : Object
    {
        /**
         * The bottom margin
         *
         * This value always represents the bottom margin, in both
         * portrait and landscape modes -- this value does't not rotate
         * with orientation.
         */
        public PrintDimension bottom_margin
        {
            get;
            set;
            default = PrintDimension(0.5, PrintUnits.IN);
        }


        /**
         * The font family
         *
         * When set to null, printing operations will use the default
         * font family.
         */
        public string? font_family
        {
            get;
            set;
            default = null;
        }


        /**
         * The horizontal alignment
         *
         * 0.0 | left
         * 0.5 | center
         * 1.0 | right
         *
         * The setter will confine values to the interval [0.0,1.0].
         */
        public double horizontal_alignment
        {
            get
            {
                return b_horizontal_alignment;
            }
            set
            {
                b_horizontal_alignment = value.clamp(0.0, 1.0);
            }
            default = 0.5;
        }


        /**
         * The left margin
         *
         * This value always represents the left margin, in both
         * portrait and landscape modes -- this value does't not rotate
         * with orientation.
         */
        public PrintDimension left_margin
        {
            get;
            set;
            default = PrintDimension(0.5, PrintUnits.IN);
        }


        /**
         * The paper orientation
         */
        public PrintOrientation orientation
        {
            get
            {
                return b_orientation;
            }
            set
            {
                if ((value >= 0) && (value < PrintOrientation.COUNT))
                {
                    b_orientation = value;
                }
            }
            default = PrintOrientation.AUTO;
        }


        /**
         * The paper height
         */
        public PrintDimension paper_height
        {
            get;
            set;
            default = PrintDimension(17.0, PrintUnits.IN);
        }


        /**
         * The name of the paper size
         *
         * When null, print operations use the paper_width and
         * paper_height properties.
         */
        public string? paper_name
        {
            get;
            set;
            default = null;
        }


        /**
         * The paper width
         */
        public PrintDimension paper_width
        {
            get;
            set;
            default = PrintDimension(11.0, PrintUnits.IN);
        }


        /**
         * The right margin
         *
         * This value always represents the right margin, in both
         * portrait and landscape modes -- this value does't not rotate
         * with orientation.
         */
        public PrintDimension right_margin
        {
            get;
            set;
            default = PrintDimension(0.5, PrintUnits.IN);
        }


        /**
         * The top margin
         *
         * This value always represents the top margin, in both
         * portrait and landscape modes -- this value does't not rotate
         * with orientation.
         */
        public PrintDimension top_margin
        {
            get;
            set;
            default = PrintDimension(0.5, PrintUnits.IN);
        }


        /**
         * Scale for printing
         */
        public double scale
        {
            get
            {
                return b_scale;
            }
            set
            {
                b_scale = value.clamp(0.0, double.MAX);
            }
            default = 1.0;
        }


        /**
         * Use color for printing
         */
        public bool use_color
        {
            get;
            set;
            default = true;
        }


        /**
         * The vertical alignment
         *
         * 0.0 | top
         * 0.5 | center
         * 1.0 | bottom
         *
         * The setter will confine values to the interval [0.0,1.0].
         */
        public double vertical_alignment
        {
            get
            {
                return b_vertical_alignment;
            }
            set
            {
                b_vertical_alignment = value.clamp(0.0, 1.0);
            }
            default = 0.5;
        }


        /**
         * Backing store for the horizontal alignment
         */
        private double b_horizontal_alignment;


        /**
         * Backing store for the orientation
         */
        private PrintOrientation b_orientation;


        /**
         * Backing store for scale
         */
        private double b_scale;


        /**
         * Backing store for the vertical alignment
         */
        private double b_vertical_alignment;
    }
}
