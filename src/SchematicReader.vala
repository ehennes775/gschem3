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
                SchematicItemBus.TYPE_ID,
                typeof(SchematicItemBus)
                );

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
         * @return the schematic item or null for no more items
         * @throws IOError
         * @throws ParseError
         */
        public SchematicItem read(DataInputStream stream) throws Error, ParseError

            requires(types != null)

        {
            var id = peek_token(stream);

            if (id == null)
            {
                return null;
            }

            if (!types.has_key(id))
            {
                throw new ParseError.UNKNOWN_ITEM_TYPE(
                    @"Unknown item type '$id'"
                    );
            }

            var type = types[id];

            var item = Object.@new(type) as SchematicItem;
            return_val_if_fail(item != null, null);
            item.read(stream);

            return item;
        }


        /**
         * Peek at the next token in the input stream
         *
         * @param stream the stream to get the token from
         * @return the token at the front of the stream
         * @return null if no more tokens or end of file
         */
        public static string? peek_token(DataInputStream stream) throws Error
        {
            string token = null;

            stream.fill(100);
            var data = (string) stream.peek_buffer();

            unichar character;
            int index = 0;
            int index0 = 0;

            var success = data.get_next_char(ref index, out character);

            while (success && character.isspace())
            {
                index0 = index;

                if (true)
                {
                    var status = stream.fill(10);
                    data = (string) stream.peek_buffer();
                }

                success = data.get_next_char(ref index, out character);
            }

            if (success)
            {
                var busy = true;
                var index1 = index;

                while (busy && !character.isspace())
                {
                    index1 = index;

                    if (true)
                    {
                        var status = stream.fill(10);
                        data = (string) stream.peek_buffer();
                    }

                    busy = data.get_next_char(ref index, out character);
                }

                token = data.slice(index0, index1);
            }

            return token;
        }


        private Gee.HashMap<string,Type> types;
    }
}
