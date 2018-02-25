namespace Geda3
{
    /**
     * Represents a graphical line in a schematic or symbol file
     */
    public class SchematicItemLine : SchematicItem,
        Grippable,
        GrippablePoints
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
         * Create a schematic graphical line
         *
         * @param x0 The x coordinate of the first point
         * @param y0 The y coordinate of the first point
         * @param x1 The x coordinate of the second point
         * @param y1 The y coordinate of the second point
         */
        public SchematicItemLine.with_points(int x0, int y0, int x1, int y1)
        {
            b_x[0] = x0;
            b_x[1] = x1;
            b_y[0] = y0;
            b_y[1] = y1;
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
        public override Bounds calculate_bounds(
            SchematicPainter painter,
            bool reveal
            )
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
        public override void invalidate_on(Invalidatable invalidatable)
        {
            var bounds = Bounds.with_points(
                b_x[0],
                b_y[0],
                b_x[1],
                b_y[1]
                );

            int expand = (int) Math.ceil(0.5 * Math.SQRT2 * b_width);

            bounds.expand(expand, expand);

            invalidatable.invalidate_bounds(bounds);
        }


        /**
         * {@inheritDoc}
         */
        public Gee.Collection<Grip> create_grips()
        {
            var grips = new Gee.ArrayList<Grip>();

            for (int index = 0; index < 2; index++)
            {
                grips.add(new PointGrip(this, index));
            }

            return grips;
        }


        /**
         * Change a point on the line
         *
         * ||''index''||''Description''||
         * ||0||The first endpoint of the line||
         * ||1||The second endpoint of the line||
         *
         * @param index The index of the point
         * @param x The new x coordinate for the point
         * @param y The new y coordinate for the point
         */
        public void get_point(int index, out int x, out int y)
        {
            if ((index < 0) || (index >= 2))
            {
                x = b_x[0];
                y = b_y[0];

                return_if_reached();
            }

            x = b_x[index];
            y = b_y[index];
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(SchematicPainter painter, bool selected = false)
        {
            painter.set_cap_type(b_cap_type);
            painter.set_color(selected ? Geda3.Color.SELECT : b_color);
            painter.set_dash(b_dash_type, b_dash_length, b_dash_space);
            painter.set_width(b_width);

            painter.draw_line(
                b_x[0],
                b_y[0],
                b_x[1],
                b_y[1]
                );
        }


        /**
         * {@inheritDoc}
         */
        public override void read_with_params(string[] params, DataInputStream stream) throws IOError, ParseError
        {
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
         * Change a point on the line
         *
         * ||''index''||''Description''||
         * ||0||The first endpoint of the line||
         * ||1||The second endpoint of the line||
         *
         * @param index The index of the point
         * @param x The new x coordinate for the point
         * @param y The new y coordinate for the point
         */
        public void set_point(int index, int x, int y)

            requires (index >= 0)
            requires (index < 2)

        {
            invalidate(this);

            b_x[index] = x;
            b_y[index] = y;

            invalidate(this);
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
