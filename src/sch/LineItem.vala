namespace Geda3
{
    /**
     * Represents a graphical line in a schematic or symbol file
     */
    public class LineItem : SchematicItem,
        Grippable,
        GrippablePoints
    {
        /**
         * The type code for a graphical line
         */
        public const string TYPE_ID = "L";


        /**
         * The color of the line
         */
        public int color
        {
            get
            {
                return b_color;
            }
            construct set
            {
                return_if_fail(value >= 0);

                b_color = value;

                invalidate(this);
            }
            default = Color.GRAPHIC;
        }


        /**
         * The line style
         */
        public LineStyle line_style
        {
            get
            {
                return b_line_style;
            }
            construct set
            {
                if (b_line_style != null)
                {
                    b_line_style.notify.disconnect(on_notify_style);
                }

                b_line_style = value ?? new LineStyle();

                b_line_style.notify.connect(on_notify_style);

                invalidate(this);
            }
        }


        /**
         * The width of the line
         */
        public int width
        {
            get
            {
                return b_width;
            }
            construct set
            {
                return_if_fail(value >= 0);

                invalidate(this);

                b_width = value;

                invalidate(this);
            }
            default = 10;
        }


        /**
         * Create a schematic graphical line
         */
        public LineItem()
        {
            b_x[0] = 0;
            b_x[1] = 0;
            b_y[0] = 0;
            b_y[1] = 0;
        }


        /**
         * Create a schematic graphical line
         *
         * @param x0 The x coordinate of the first point
         * @param y0 The y coordinate of the first point
         * @param x1 The x coordinate of the second point
         * @param y1 The y coordinate of the second point
         */
        public LineItem.with_points(int x0, int y0, int x1, int y1)
        {
            b_x[0] = x0;
            b_x[1] = x1;
            b_y[0] = y0;
            b_y[1] = y1;
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
        public override void draw(
            SchematicPainter painter,
            bool reveal,
            bool selected
            )
        {
            painter.set_cap_type(line_style.cap_type);
            painter.set_color(selected ? Geda3.Color.SELECT : b_color);

            painter.set_dash(
                line_style.dash_type,
                line_style.dash_length,
                line_style.dash_space
                );

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
                    @"Line with incorrect parameter count"
                    );
            }

            return_if_fail(params[0] == TYPE_ID);

            b_x[0] = Coord.parse(params[1]);
            b_y[0] = Coord.parse(params[2]);
            b_x[1] = Coord.parse(params[3]);
            b_y[1] = Coord.parse(params[4]);
            b_color = Color.parse(params[5]);
            b_width = Coord.parse(params[6]);

            line_style.set_from_params(params[7:11]);
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
                line_style.cap_type,
                line_style.dash_type,
                line_style.dash_type.uses_length() ? line_style.dash_length : -1,
                line_style.dash_type.uses_space() ? line_style.dash_space : -1
                );

            stream.write_all(output.data, null);
        }


        /**
         * Backing store for the color
         */
        private int b_color;


        /**
         * The backing store for the line style
         */
        private LineStyle b_line_style;


        /**
         * The backing store for the line width
         */
        private int b_width;


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


        /**
         * Signal handler when a line style property changes
         */
        private void on_notify_style(ParamSpec param)
        {
            invalidate(this);
        }
    }
}