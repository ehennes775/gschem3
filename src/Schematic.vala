namespace Geda3
{
    public class Schematic
    {
        /**
         *
         */
        public Gee.Collection<SchematicItem> items
        {
            owned get
            {
                return m_items.read_only_view;
            }
        }


        /**
         *
         */
        public FileVersion version
        {
            get;
            private set;
        }

        /**
         * Create an empty schematic
         */
        public Schematic()
        {
            m_items = new Gee.LinkedList<SchematicItem>();
            version = FileVersion.LATEST;
        }


        /**
         * Add an item to the schematic
         *
         * @param item the item to add
         * @return true if the item was added
         */
        public bool add(SchematicItem item)
        {
            return m_items.add(item);
        }


        /**
         * Calculate the bounds of this schematic
         *
         * @param painter The painter to use for bounds calculation
         */
        public Bounds calculate_bounds(
            SchematicPainter painter,
            bool reveal
            )
        {
            Geda3.Bounds bounds = Geda3.Bounds();

            foreach (var item in m_items)
            {
                bounds.union(item.calculate_bounds(painter, reveal));

                var parent = item as AttributeParent;

                if (parent != null)
                {
                    foreach (var child in parent.attributes)
                    {
                        bounds.union(child.calculate_bounds(painter, reveal));
                    }
                }
            }

            return bounds;
        }



        /**
         * Draw the schematic
         *
         * @param painter the painter to use for drawing
         */
        public void draw(SchematicPainter painter)
        {
            foreach (var item in m_items)
            {
                item.draw(painter, false, false);
            }
        }


        /**
         * Read a schematic from an input file
         *
         * @param file the file to read the schematic from
         * @throws Error TBD
         */
        public void read_from_file(File file) throws Error
        {
            var stream = new DataInputStream(file.read());

            read(stream);
        }


        /**
         * Read a schematic from an input stream
         *
         * @param stream the stream to read the schematic from
         * @throws Error TBD
         */
        public void read(DataInputStream stream) throws Error

            requires(m_items != null)

        {
            m_items.clear();

            version = FileVersion.read(stream);

            var item = reader.read(stream);

            while (item != null)
            {
                add(item);

                item = reader.read(stream);
            }
        }


        /**
         * Write schematic to an output stream
         *
         * @param stream the stream to write the schematic to
         * @throws IOError TBD
         */
        public void write(DataOutputStream stream) throws IOError

            requires(m_items != null)

        {
            version.write(stream);

            foreach (var item in m_items)
            {
                item.write(stream);

                var parent = item as AttributeParent;

                if (parent != null)
                {
                    stream.put_string("{\n");

                    foreach (var child in parent.attributes)
                    {
                        child.write(stream);
                    }

                    stream.put_string("}\n");
                }
            }
        }


        private Gee.LinkedList<SchematicItem> m_items;

        private SchematicReader reader = new SchematicReader();
    }
}
