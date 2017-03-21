namespace Geda3
{
    public class Schematic
    {
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
            items = new Gee.LinkedList<SchematicItem>();
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
            return items.add(item);
        }


        /**
         * Draw the schematic
         *
         * @param painter the painter to use for drawing
         */
        public void draw(SchematicPainter painter)
        {
            foreach (var item in items)
            {
                item.draw(painter);
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

            requires(items != null)

        {
            items.clear();

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

            requires(items != null)

        {
            version.write(stream);

            foreach (var item in items)
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


        private Gee.LinkedList<SchematicItem> items;

        private SchematicReader reader = new SchematicReader();
    }
}
