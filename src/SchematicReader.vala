namespace Geda3
{
    public class SchematicReader
    {
        /**
         * Create a default schematic reader
         */
        public SchematicReader()
        {
            types = new Gee.HashMap<string,Type>();

            types.@set(
                SchematicItemLine.TYPE_ID,
                typeof(SchematicItemLine)
                );

            types.@set(
                SchematicItemNet.TYPE_ID,
                typeof(SchematicItemNet)
                );
        }


        /**
         * Read a schematic item from an input stream
         *
         * @param stream the stream to read the schematic item from
         * @return the schematic item
         * @throws IOError
         * @throws ParseError
         */
        public SchematicItem read(DataInputStream stream) throws IOError, ParseError

            requires(types != null)

        {
            stream.fill(10);
            var data = (string) stream.peek_buffer();
            var split = data.split_set(" " ,2);
            var id = split[0];
            
            var type = types[id];

            var item = Object.@new(type) as SchematicItem;
            return_val_if_fail(item != null, null);
            item.read(stream);

            return item;
        }


        private Gee.HashMap<string,Type> types;
    }
}
