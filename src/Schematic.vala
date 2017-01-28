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
            version = FileVersion()
            {
                file_version = FileVersion.LATEST.file_version,
                tool_version = FileVersion.LATEST.tool_version
            };
            
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
         * Read a schematic from an input file
         *
         * @param file the file to read the schematic from
         * @throws IOError
         * @throws ParseError
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
         * @throws IOError
         * @throws ParseError
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
         * @throws IOError
         */
        public void write(DataOutputStream stream) throws IOError

            requires(items != null)

        {
            version.write(stream);

            foreach (var item in items)
            {
                item.write(stream);
            }
        }


        private Gee.LinkedList<SchematicItem> items;

        private SchematicReader reader = new SchematicReader();
    }
}
