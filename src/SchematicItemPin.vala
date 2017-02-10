namespace Geda3
{
    /**
     * Represents a pin on a schematic
     */
    public class SchematicItemPin : SchematicItem
    {
        /**
         * The type code, for a pin, used in schematic files
         */
        public const string TYPE_ID = "P";


        /**
         * Create a schematic pin
         */
        public SchematicItemPin()
        {
            b_x[0] = 0;
            b_x[1] = 0;
            b_y[0] = 0;
            b_y[1] = 0;
            b_color = Color.PIN;
            b_type = PinType.NORMAL;
            b_end = 0;
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

            var width =
                (b_type == PinType.BUS) ? SchematicItemBus.WIDTH :
                SchematicItemNet.WIDTH;

            int expand = (int) Math.ceil(0.5 * Math.SQRT2 * width);

            bounds.expand(expand, expand);

            return bounds;
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(SchematicPainter painter)
        {
            painter.set_cap_type(CapType.NONE);
            painter.set_color(b_color);
            painter.set_dash(DashType.SOLID, 0, 0);
        }


        /**
         * {@inheritDoc}
         */
        public override void read(DataInputStream stream) throws IOError, ParseError
        {
            var input = stream.read_line(null);

            var params = input.split(" ");

            if (params.length != 8)
            {
                throw new ParseError.PARAMETER_COUNT(
                    @"Pin with incorrect parameter count"
                    );
            }

            return_if_fail(params[0] == TYPE_ID);

            b_x[0] = Coord.parse(params[1]);
            b_y[0] = Coord.parse(params[2]);
            b_x[1] = Coord.parse(params[3]);
            b_y[1] = Coord.parse(params[4]);
            b_color = Color.parse(params[5]);
            b_type = PinType.parse(params[6]);
            b_end = Coord.parse(params[7]);
        }


        /**
         * {@inheritDoc}
         */
        public override void write(DataOutputStream stream) throws IOError
        {
            var output = "%s %d %d %d %d %d %d %d\n".printf(
                TYPE_ID,
                b_x[0],
                b_y[0],
                b_x[1],
                b_y[1],
                b_color,
                b_type,
                b_end
                );

            stream.write_all(output.data, null);
        }


        /**
         * Backing store the color
         *
         * Temporarily public for testing
         */
        public int b_color;


        /**
         * Backing store for the end
         *
         * Temporarily public for testing
         */
        public int b_end;


        /**
         * Backing store for the pin type
         *
         * Temporarily public for testing
         */
        public int b_type;


        /**
         * Backing store the x coordinates
         *
         * Temporarily public for testing
         */
        public int b_x[2];


        /**
         * Backing store the y coordinates
         *
         * Temporarily public for testing
         */
        public int b_y[2];
    }
}
