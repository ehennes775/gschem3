
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
        public ComplexItem(ComplexLibrary library)
        {
            Object(
                library : library
                );
        }


        /**
         * {@inheritDoc}
         */
        public void attach(AttributeChild attribute)

            requires(m_attributes != null) 

        {
            m_attributes.add(attribute);

            m_unpromoted_items = fetch_unpromoted_items();
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

            return bounds;
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
        public override void draw(
            SchematicPainter painter,
            bool reveal,
            bool selected
            )
        {
            //if (m_symbol != null)
            //{
            //   m_symbol.draw(
            //        b_insert_x,
            //        b_insert_y,
            //        painter,
            //        reveal,
            //        selected
            //        );
            //}

            painter.draw_items(
                b_insert_x,
                b_insert_y,
                m_unpromoted_items
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
         * Change a point on the complex shape
         *
         * ||''index''||''Description''||
         * ||0||The insertion point||
         *
         * @param index The index of the point
         * @param x The new x coordinate for the point
         * @param y The new y coordinate for the point
         */
        public void set_point(int index, int x, int y)

            requires (index == 0)

        {
            invalidate(this);

            b_insert_x = x;
            b_insert_y = y;

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

            return unpromoted;
        }
    }
}
