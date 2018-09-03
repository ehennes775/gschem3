namespace Geda3
{
    /**
     * Represents a bus on a schematic
     */
    public class BusItem : SchematicItem, AttributeParent
    {
        /**
         * The type code, for a bus, used in schematic files
         */
        public const string TYPE_ID = "U";


        /**
         * The width to use for drawing busses
         */
        public const int WIDTH = 30;


        /**
         * {@inheritDoc}
         */
        public Gee.List<AttributeChild> attributes
        {
            owned get
            {
                return m_attributes.read_only_view;
            }
        }


        /**
         * GObject initialization
         */
        construct
        {
            m_attributes = new Gee.LinkedList<AttributeChild>();
        }


        /**
         * Create a schematic bus
         */
        public BusItem()
        {
            b_x[0] = 0;
            b_x[1] = 0;
            b_y[0] = 0;
            b_y[1] = 0;
            b_color = Color.BUS;
            b_direction = 0;
        }


        /**
         * Create a schematic bus
         */
        public BusItem.with_points(int x0, int y0, int x1, int y1)
        {
            b_x[0] = x0;
            b_x[1] = x1;
            b_y[0] = y0;
            b_y[1] = y1;
            b_color = Color.BUS;
            b_direction = 0;
        }


        /**
         * {@inheritDoc}
         */
        public void attach(AttributeChild attribute)

            requires(m_attributes != null) 

        {
            m_attributes.add(attribute);
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

            int expand = (int) Math.ceil(0.5 * Math.SQRT2 * WIDTH);

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

            int expand = (int) Math.ceil(0.5 * Math.SQRT2 * WIDTH);

            bounds.expand(expand, expand);

            invalidatable.invalidate_bounds(bounds);
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
            painter.set_cap_type(CapType.SQUARE);
            painter.set_color(selected ? Geda3.Color.SELECT : b_color);
            painter.set_dash(DashType.SOLID, 0, 0);
            painter.set_width(WIDTH);

            painter.draw_line(
                b_x[0],
                b_y[0],
                b_x[1],
                b_y[1]
                );

            foreach (var attribute in m_attributes)
            {
                attribute.draw(painter, reveal, selected);
            }
        }


        /**
         * {@inheritDoc}
         */
        public override void read_with_params(string[] params, DataInputStream stream) throws IOError, ParseError
        {
            if (params.length != 7)
            {
                throw new ParseError.PARAMETER_COUNT(
                    @"Bus with incorrect parameter count"
                    );
            }

            return_if_fail(params[0] == TYPE_ID);

            b_x[0] = Coord.parse(params[1]);
            b_y[0] = Coord.parse(params[2]);
            b_x[1] = Coord.parse(params[3]);
            b_y[1] = Coord.parse(params[4]);
            b_color = Color.parse(params[5]);
            b_direction = Coord.parse(params[6]);
        }


        /**
         * {@inheritDoc}
         */
        public override void write(DataOutputStream stream) throws IOError
        {
            var output = "%s %d %d %d %d %d %d\n".printf(
                TYPE_ID,
                b_x[0],
                b_y[0],
                b_x[1],
                b_y[1],
                b_color,
                b_direction
                );

            stream.write_all(output.data, null);
        }


        /**
         * The attributes attached to this item
         */
        private Gee.LinkedList<AttributeChild> m_attributes;


        /**
         * Backing store the color
         *
         * Temporarily public for testing
         */
        public int b_color;


        /**
         * Backing store for the direction
         *
         * Temporarily public for testing
         */
        public int b_direction;


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
