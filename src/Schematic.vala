namespace Geda3
{
    public class Schematic
    {
        /**
         * Create an empty schematic
         */
        public Schematic()
        {
            items = new Gee.LinkedList<SchematicItem>();
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
         * Read a schematic from an input stream
         *
         * @param stream the stream to read the schematic from
         * @throws IOError
         * @throws ParseError
         */
        public void read(DataInputStream stream) throws IOError, ParseError

            requires(items != null)

        {
            items.clear();

            for (int count = 0; count < 10; count++)
            {
                var item = reader.read(stream);

                add(item);
            }
        }


        /**
         * Write schematic to an output stream
         *
         * @param stream the stream to write the schematic to
         * @throws IOError
         */
        public void write(DataOutputStream stream) throws IOError

            requires(items != null)

        {
            // TODO: Write the version line

            foreach (var item in items)
            {
                item.write(stream);
            }
        }


        private Gee.LinkedList<SchematicItem> items;

        private SchematicReader reader = new SchematicReader();
    }
}
