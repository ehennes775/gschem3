namespace Geda3
{
    /**
     * Represents a graphical line in a schematic or symbol file
     */
    public class SchematicItemLine : SchematicItem
    {
        /**
         * The type code for a graphical line
         */
        public const string TYPE_ID = "L";


        /**
         * Create a schematic graphical line
         */
        public SchematicItemLine()
        {
            b_x[0] = 0;
            b_x[1] = 0;
            b_y[0] = 0;
            b_y[1] = 0;
            b_color = Color.GRAPHIC;
            b_width = 10;
            b_cap_type = CapType.NONE;
            b_dash_type = DashType.SOLID;
            b_dash_length = DashType.DEFAULT_LENGTH;
            b_dash_space = DashType.DEFAULT_SPACE;
        }


        /**
         * {@inheritDoc}
         */
        public override Bounds calculate_bounds(SchematicPainter painter)
        {
            var bounds = Bounds.with_points(
                b_x[0],
                b_y[0],
                b_x[1],
                b_y[1]
                );

            int expand = (int) Math.ceil(0.5 * Math.SQRT2 * b_width);

            bounds.expand(expand, expand);

            return bounds;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(SchematicPainter painter)
        {
            painter.set_cap_type(b_cap_type);
            painter.set_color(b_color);
            painter.set_dash(b_dash_type, b_dash_length, b_dash_space);
        }


        /**
         * {@inheritDoc}
         */
        public override void read(DataInputStream stream) throws IOError, ParseError
        {
            var input = stream.read_line(null);

            var params = input.split(" ");

            if (params.length != 11)
            {
                throw new ParseError.PARAMETER_COUNT(
                    @"Net with incorrect parameter count"
                    );
            }

            return_if_fail(params[0] == TYPE_ID);

            b_x[0] = Coord.parse(params[1]);
            b_y[0] = Coord.parse(params[2]);
            b_x[1] = Coord.parse(params[3]);
            b_y[1] = Coord.parse(params[4]);
            b_color = Color.parse(params[5]);
            b_width = Coord.parse(params[6]);
            b_cap_type = CapType.parse(params[7]);
            b_dash_type = DashType.parse(params[8]);
            b_dash_length = b_dash_type.parse_length(params[9]);
            b_dash_space = b_dash_type.parse_space(params[10]);
        }


        /**
         * {@inheritDoc}
         */
        public override void write(DataOutputStream stream) throws IOError
        {
            var output = "%s %d %d %d %d %d %d %d %d %d %d\n".printf(
                TYPE_ID,
                b_x[0],
                b_y[0],
                b_x[1],
                b_y[1],
                b_color,
                b_width,
                b_cap_type,
                b_dash_type,
                b_dash_type.uses_length() ? b_dash_length : -1,
                b_dash_type.uses_space() ? b_dash_space : -1
                );

            stream.write_all(output.data, null);
        }


        /**
         * Backing store for the cap type
         *
         * Temporarily public for testing
         */
        public CapType b_cap_type;


        /**
         * Backing store for the color
         *
         * Temporarily public for testing
         */
        public int b_color;


        /**
         * Backing store for the dash length
         *
         * Temporarily public for testing
         */
        public int b_dash_length;


        /**
         * Backing store for the dash space
         *
         * Temporarily public for testing
         */
        public int b_dash_space;


        /**
         * Backing store for the dash type
         *
         * Temporarily public for testing
         */
        public DashType b_dash_type;


        /**
         * Backing store for the line width
         *
         * Temporarily public for testing
         */
        public int b_width;


        /**
         * Backing store for the x coordinates
         *
         * Temporarily public for testing
         */
        public int b_x[2];


        /**
         * Backing store for the y coordinates
         *
         * Temporarily public for testing
         */
        public int b_y[2];
    }
}
