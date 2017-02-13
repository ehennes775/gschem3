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
                NetItem.TYPE_ID,
                typeof(NetItem)
                );

            types.@set(
                SchematicItemPin.TYPE_ID,
                typeof(SchematicItemPin)
                );

            types.@set(
                TextItem.TYPE_ID,
                typeof(TextItem)
                );
        }


        /**
         * Read a schematic item from an input stream
         *
         * @param stream the stream to read the schematic item from
         * @return the schematic item or null for no more items
         * @throws Error TBD
         * @throws ParseError TBD
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

            id = peek_token(stream);

            if ((id != null) && (id == "{"))
            {
                var parent_item = item as AttributeParent;

                if (parent_item == null)
                {
                    throw new ParseError.UNKNOWN_ITEM_TYPE(
                        @"001 Unknown item type '$id'"
                        );
                }

                stream.read_line(null);

                id = peek_token(stream);

                if (id == null)
                {
                    // unexpected end of file
                }

                while (id != "}")
                {
                    if (!types.has_key(id))
                    {
                        throw new ParseError.UNKNOWN_ITEM_TYPE(
                            @"002 Unknown item type '$id'"
                            );
                    }

                    var child_item = Object.@new(types[id]) as AttributeChild;
                    
                    if (child_item == null)
                    {
                        throw new ParseError.UNKNOWN_ITEM_TYPE(
                            @"003 Unknown item type '$id'"
                            );
                    }

                    child_item.read(stream);

                    parent_item.attach(child_item);

                    id = peek_token(stream);

                    if (id == null)
                    {
                        // unexpected end of file
                    }
                }

                if (id == "}")
                {
                    stream.read_line(null);
                }
            }

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
