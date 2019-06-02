namespace Geda3
{
    /**
     * Represents a component on a schematic
     *
     * ||0||string||The constant 'C' indicating a complex shape||
     * ||1||int32 ||X coordinate of the insertion point        ||
     * ||2||int32 ||Y coordinate of the insertion point        ||
     * ||3||int32 ||Indicates if the item is selectable        ||
     * ||4||int32 ||Rotation angle                             ||
     * ||5||int32 ||Mirroring                                  ||
     * ||6||string||The name of the component                  ||
     */
    public class ComplexItem : SchematicItem, AttributeParent
    {
        /**
         * The type code used in schematic files
         */
        public const string TYPE_ID = "C";


        /**
         *
         */
        public int angle
        {
            get
            {
                return b_angle;
            }
            construct set
            {
                invalidate(this);

                b_angle = value;

                invalidate(this);
            }
            default = 0;
        }


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
         *
         */
        public ComplexLibrary library
        {
            get;
            construct;
        }


        /**
         *
         */
        public bool mirror
        {
            get
            {
                return b_mirror != 0;
            }
            construct set
            {
                invalidate(this);

                b_mirror = value ? 1 : 0;

                invalidate(this);
            }
            default = false;
        }


        /**
         * Slotting mechanism
         */
        public Slotter slotter
        {
            get;
            construct;
        }


        public ComplexSymbol symbol
        {
            get
            {
                return m_symbol;
            }
        }


        public int insert_x
        {
            get
            {
                return b_insert_x;
            }
        }


        public int insert_y
        {
            get
            {
                return b_insert_y;
            }
        }


        /**
         * GObject initialization
         */
        construct
        {
            m_attributes = new Gee.LinkedList<AttributeChild>();
            m_unpromoted_items = new Gee.ArrayList<SchematicItem>();
        }


        /**
         * Initialize a new instance
         */
        public ComplexItem(ComplexLibrary library, Slotter slotter)
        {
            Object(
                library : library,
                slotter : slotter
                );
        }


        /**
         * Initialize a new instance
         */
        public ComplexItem.with_name(
            ComplexLibrary library,
            Slotter slotter,
            string name
            )
        {
            Object(
                library : library,
                slotter : slotter
                );

            b_insert_x = 0;
            b_insert_y = 0;
            b_selectable = 1;
            b_mirror = 0;
            b_name = name;

            m_symbol = library.@get(b_name);

            m_unpromoted_items = fetch_unpromoted_items();
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

            m_unpromoted_items = fetch_unpromoted_items();

            attached(attribute, this);

            invalidate(this);
        }


        /**
         * {@inheritDoc}
         */
        public override Bounds calculate_bounds(
            SchematicPainter painter,
            bool reveal
            )
        {
            var bounds = Bounds();

            foreach (var item in m_unpromoted_items)
            {
                var temp_bounds = item.calculate_bounds(
                    painter,
                    reveal
                    );

                // Process in the order of mirror, rotate, translate to
                // be compatible with the file format.

                if (b_mirror != 0)
                {
                    temp_bounds.mirror_x();
                }

                temp_bounds.rotate(b_angle);
                temp_bounds.translate(b_insert_x, b_insert_y);

                bounds.union(temp_bounds);
            }

            return bounds;
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

                m_unpromoted_items = fetch_unpromoted_items();

                detached(attribute, this);

                invalidate(this);
            }
        }


        /**
         * {@inheritDoc}
         */
        public override void invalidate_on(Invalidatable invalidatable)
        {
            var bounds = Bounds();

            invalidatable.invalidate_bounds(bounds);
        }


        /**
         * {@inheritDoc}
         */
        public override bool locate_insertion_point(
            out int x,
            out int y
            )
        {
            x = b_insert_x;
            y = b_insert_y;

            return true;
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
            painter.draw_items(
                b_insert_x,
                b_insert_y,
                b_angle,
                b_mirror != 0,
                m_unpromoted_items,
                reveal,
                selected
                );

            foreach (var item in m_unpromoted_items)
            {
                var parent = item as AttributeParent;

                if (parent != null)
                {
                    painter.draw_items(
                        b_insert_x,
                        b_insert_y,
                        b_angle,
                        b_mirror != 0,
                        parent.attributes,
                        reveal,
                        selected
                        );
                }
            }
        }


        /**
         * {@inheritDoc}
         */
        public override bool intersects_box(
            SchematicPainter painter,
            Bounds box
            )

            requires(m_unpromoted_items != null)

        {
            var temp_bounds = box;

            temp_bounds.translate(-b_insert_x, -b_insert_y);
            temp_bounds.rotate(-b_angle);

            if (b_mirror != 0)
            {
                temp_bounds.mirror_x();
            }

            foreach (var item in m_unpromoted_items)
            {
                if (item.intersects_box(painter, temp_bounds))
                {
                    return true;
                }
            }

            return false;
        }


        /**
         * {@inheritDoc}
         */
        public override void mirror_x(int cx)
        {
            invalidate(this);

            b_angle = Angle.normalize(-b_angle);
            b_insert_x = 2 * cx - b_insert_x;

            mirror = !mirror;    // includes an invalidate(this);
        }
        

        /**
         * {@inheritDoc}
         */
        public override void mirror_y(int cy)
        {
            invalidate(this);

            b_angle = Angle.normalize(180 - b_angle);
            b_insert_y = 2 * cy - b_insert_y;

            mirror = !mirror;    // includes an invalidate(this);
        }


        /**
         * {@inheritDoc}
         */
        public override void read_with_params(string[] params, DataInputStream stream) throws IOError, ParseError
        {
            if (params.length != 7)
            {
                throw new ParseError.PARAMETER_COUNT(
                    @"Arc with incorrect parameter count"
                    );
            }

            return_if_fail(params[0] == TYPE_ID);

            b_insert_x = Coord.parse(params[1]);
            b_insert_y = Coord.parse(params[2]);
            b_selectable = Coord.parse(params[3]);
            b_angle = Coord.parse(params[4]);
            b_mirror = Coord.parse(params[5]);
            b_name = params[6];

            m_symbol = library.@get(b_name);

            m_unpromoted_items = fetch_unpromoted_items();
        }


        /**
         * {@inheritDoc}
         */
        public override void rotate(int cx, int cy, int angle)
        {
            invalidate(this);

            b_angle = Geda3.Angle.normalize(b_angle + angle);

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
            return_val_if_fail(m_unpromoted_items != null, double.MAX);

            var distance = double.MAX;

            foreach (var item in m_unpromoted_items)
            {
                var temp_x = x - b_insert_x;
                var temp_y = y - b_insert_y;

                var temp_distance = item.shortest_distance(
                    painter,
                    temp_x,
                    temp_y
                    );

                distance = double.min(distance, temp_distance);
            }

            return distance;
        }


        /**
         * {@inheritDoc}
         */
        public override void translate(int dx, int dy)
        {
            invalidate(this);

            b_insert_x += dx;
            b_insert_y += dy;

            invalidate(this);
        }


        /**
         * {@inheritDoc}
         */
        public override void write(DataOutputStream stream) throws IOError
        {
            var output = "%s %d %d %d %d %d %s\n".printf(
                TYPE_ID,
                b_insert_x,
                b_insert_y,
                b_selectable,
                b_angle,
                b_mirror,
                b_name
                );

            stream.write_all(output.data, null);
        }


        /**
         * Backing store for the rotation angle
         */
        private int b_angle;


        /**
         * The attributes attached to this item
         */
        private Gee.LinkedList<AttributeChild> m_attributes;


        /**
         * Backing store for the insertion point x coordinate
         */
        private int b_insert_x;


        /**
         * Backing store for the insertion point x coordinate
         */
        private int b_insert_y;


        /**
         * Backing store for mirroring
         */
        private int b_mirror;


        /**
         * Backing store for symbol name
         */
        private string b_name;


        private ComplexSymbol m_symbol;


        /**
         * Backing store indicating the component is selctable
         */
        private int b_selectable;


        /**
         * A list of the unpromoted schematic items
         */
        private Gee.List<SchematicItem> m_unpromoted_items;


        /**
         * Provides a set of the promoted attribute names
         *
         * @return A set of the promoted attribute names
         */
        private Gee.Set<string> fetch_promoted_names()
        {
            var promoted = new Gee.HashSet<string>();

            return_val_if_fail(m_attributes != null, promoted);

            foreach (var attribute in m_attributes)
            {
                var name = attribute.name;

                if (name == null)
                {
                    continue;
                }

                promoted.add(name);
            }

            return promoted;
        }


        /**
         * Provides a list of items, in the symbol, that have not been
         * promoted
         *
         * @return A list of the schematic items that have not been
         * promoted.
         */
        private Gee.List<SchematicItem> fetch_unpromoted_items()
        {
            var promoted = fetch_promoted_names();
            var unpromoted = new Gee.ArrayList<SchematicItem>();

            return_val_if_fail(m_symbol != null, unpromoted);
            return_val_if_fail(m_symbol.schematic != null, unpromoted);
            return_val_if_fail(m_symbol.schematic.items != null, unpromoted);
            return_val_if_fail(promoted != null, unpromoted);

            foreach (var item in m_symbol.schematic.items)
            {
                var attribute = item as AttributeChild;

                if (attribute == null)
                {
                    unpromoted.add(item);
                    continue;
                }

                var name = attribute.name;

                if (name == null)
                {
                    unpromoted.add(item);
                    continue;
                }

                if (promoted.contains(name))
                {
                    continue;
                }

                unpromoted.add(item);
            }

            if (slotter != null)
            {
                return slotter.slot_attributes(
                    m_symbol.schematic.items,
                    unpromoted
                    );
            }

            return unpromoted;
        }
    }
}
