namespace Geda3
{
    /**
     * Represents a pin on a schematic
     */
    public class SchematicItemPin : SchematicItem, AttributeParent
    {
        /**
         * The type code, for a pin, used in schematic files
         */
        public const string TYPE_ID = "P";


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
         * Create a schematic pin
         */
        public SchematicItemPin()
        {
            b_x[0] = 0;
            b_x[1] = 0;
            b_y[0] = 0;
            b_y[1] = 0;
            b_color = Color.PIN;
            b_type = PinType.NET;
            b_end = 0;
        }

        /**
         * Create a schematic pin
         *
         * @param x0 The x coordinate of the first point
         * @param y0 The y coordinate of the first point
         * @param x1 The x coordinate of the second point
         * @param y1 The y coordinate of the second point
         */
        public SchematicItemPin.with_points(int x0, int y0, int x1, int y1)
        {
            b_x[0] = x0;
            b_x[1] = x1;
            b_y[0] = y0;
            b_y[1] = y1;
            b_color = Color.PIN;
            b_type = PinType.NET;
            b_end = 0;
        }


        /**
         * {@inheritDoc}
         */
        public void attach(AttributeChild attribute)

            requires(m_attributes != null) 

        {
            m_attributes.add(attribute);

            attribute.invalidate.connect(on_invalidate);
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
                (b_type == PinType.BUS) ? BusItem.WIDTH : NetItem.WIDTH;

            int expand = (int) Math.ceil(0.5 * Math.SQRT2 * width);

            bounds.expand(expand, expand);

            return bounds;
        }


        /**
         * Get the first attribute with the given name
         */
        public TextItem? get_attribute(string name)
        {
            foreach (var item in m_attributes)
            {
                var text = item as TextItem;

                if ((text != null) && (text.name == name))
                {
                    return text;
                }
            }

            return null;
        }


        public void get_point(int index, ref int x, ref int y)

            requires(index >= 0)
            requires(index < 2)

        {
            x = b_x[index];
            y = b_y[index];
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

            var width =
                (b_type == PinType.BUS) ? BusItem.WIDTH : NetItem.WIDTH;

            int expand = (int) Math.ceil(0.5 * Math.SQRT2 * width);

            bounds.expand(expand, expand);

            invalidatable.invalidate_bounds(bounds);
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(SchematicPainter painter, bool selected = false)
        {
            painter.set_cap_type(CapType.NONE);
            painter.set_color(selected ? Geda3.Color.SELECT : b_color);
            painter.set_dash(DashType.SOLID, 0, 0);
            painter.set_width((b_type == PinType.BUS) ? BusItem.WIDTH : NetItem.WIDTH);

            painter.draw_line(
                b_x[0],
                b_y[0],
                b_x[1],
                b_y[1]
                );

            foreach (var attribute in m_attributes)
            {
                var item = attribute as SchematicItem;

                if (item != null)
                {
                    item.draw(painter, selected);
                }
            }
        }


        /**
         * {@inheritDoc}
         */
        public override void read_with_params(string[] params, DataInputStream stream) throws IOError, ParseError
        {
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
         * Change a point on the pin
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


        private void on_invalidate(SchematicItem item)
        {
            invalidate(item);
        }
    }
}
