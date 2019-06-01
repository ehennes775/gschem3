namespace Geda3
{
    /**
     * Represents a bus on a schematic
     */
    public class BusItem : SchematicItem,
        AttributeParent,
        Grippable,
        GrippablePoints
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

            attribute.invalidate.connect(on_invalidate);
            attribute.notify["name"].connect(on_notify_attribute);
            attribute.notify["value"].connect(on_notify_attribute);

            attached(attribute, this);
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
        public Gee.Collection<Grip> create_grips(
            GripAssistant assistant
            )
        {
            var grips = new Gee.ArrayList<Grip>();

            for (int index = 0; index < 2; index++)
            {
                grips.add(new PointGrip(assistant, this, index));
            }

            return grips;
        }


        /**
         * {@inheritDoc}
         */
        public void detach(AttributeChild attribute)

            requires(m_attributes != null) 

        {
            var success = m_attributes.remove(attribute);

            if (success)
            {
                attribute.invalidate.connect(on_invalidate);
                attribute.notify["name"].connect(on_notify_attribute);
                attribute.notify["value"].connect(on_notify_attribute);

                detached(attribute, this);
            }
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
        }


        /**
         * {@inheritDoc}
         */
        public override bool intersects_box(
            SchematicPainter painter,
            Bounds box
            )
        {
            return false;
        }


        /**
         * {@inheritDoc}
         */
        public override bool locate_insertion_point(
            out int x,
            out int y
            )
        {
            x = int.min(b_x[0], b_x[1]);
            y = int.min(b_y[0], b_y[1]);

            return true;
        }


        /**
         * {@inheritDoc}
         */
        public override void mirror_x(int cx)
        {
            invalidate(this);

            for (var index = 0; index < b_x.length; index++)
            {
                b_x[index] = 2 * cx - b_x[index];
            }

            invalidate(this);

            foreach (var attribute in attributes)
            {
                attribute.mirror_x(cx);
            }
        }


        /**
         * {@inheritDoc}
         */
        public override void mirror_y(int cy)
        {
            invalidate(this);

            for (var index = 0; index < b_y.length; index++)
            {
                b_y[index] = 2 * cy - b_y[index];
            }

            invalidate(this);

            foreach (var attribute in attributes)
            {
                attribute.mirror_y(cy);
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
        public override void rotate(int cx, int cy, int angle)

            requires(b_x.length == b_y.length)

        {
            invalidate(this);

            for (var index = 0; index < b_x.length; index++)
            {
                Coord.rotate(cx, cy, angle, ref b_x[index], ref b_y[index]);
            }

            invalidate(this);

            foreach (var attribute in attributes)
            {
                attribute.rotate(cx, cy, angle);
            }
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
        public override double shortest_distance(
            SchematicPainter painter,
            int x,
            int y
            )
        {
            double dx;
            double dy;

            var lx0 = (double)b_x[0];
            var ly0 = (double)b_y[0];
            var ldx = (double)(b_x[1] - lx0);
            var ldy = (double)(b_y[1] - ly0);

            if (ldx == 0 && ldy == 0)
            {
                dx = x - lx0;
                dy = y - ly0;
            }
            else
            {
                var dx0 = ldx * (x - lx0);
                var dy0 = ldy * (y - ly0);

                var t = (dx0 + dy0) / (ldx * ldx + ldy * ldy);

                t = t.clamp(0.0, 1.0);

                var cx = t * ldx + lx0;
                var cy = t * ldy + ly0;

                dx = x - cx;
                dy = y - cy;
            }

            return Math.hypot(dx, dy);
        }


        /**
         * {@inheritDoc}
         */
        public override void translate(int dx, int dy)
        {
            invalidate(this);

            b_x[0] += dx;
            b_y[0] += dy;
            b_x[1] += dx;
            b_y[1] += dy;

            foreach (var attribute in attributes)
            {
                attribute.translate(dx, dy);
            }

            invalidate(this);
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
