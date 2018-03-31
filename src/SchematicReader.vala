namespace Geda3
{
    public class SchematicReader
    {
        /**
         * Create a default schematic reader
         */
        public SchematicReader()
        {
            m_types = new Gee.HashMap<string,Type>();

            m_types.@set(
                ArcItem.TYPE_ID,
                typeof(ArcItem)
                );

            m_types.@set(
                BoxItem.TYPE_ID,
                typeof(BoxItem)
                );

            m_types.@set(
                BusItem.TYPE_ID,
                typeof(BusItem)
                );

            m_types.@set(
                CircleItem.TYPE_ID,
                typeof(CircleItem)
                );

            m_types.@set(
                LineItem.TYPE_ID,
                typeof(LineItem)
                );

            m_types.@set(
                NetItem.TYPE_ID,
                typeof(NetItem)
                );

            m_types.@set(
                PinItem.TYPE_ID,
                typeof(PinItem)
                );

            m_types.@set(
                TextItem.TYPE_ID,
                typeof(TextItem)
                );
        }


        /**
         * Read a schematic item from an input stream
         *
         * @param line the next line to be read as a lookahead
         * @param stream the stream to read the schematic item from
         * @return the schematic item or null for no more items
         * @throws Error TBD
         * @throws ParseError TBD
         */
        public SchematicItem read(ref string line, DataInputStream stream) throws Error, ParseError

            requires(line != null)
            requires(m_types != null)

        {
            var params = line.split(" ");

            var id = params[0];

            var item = read_item(params, stream);

            line = stream.read_line(null);

            if (line == null)
            {
                return item;
            }
            
            params = line.split(" ");

            id = params[0];

            if (id == "{")
            {
                var parent_item = item as AttributeParent;

                if (parent_item == null)
                {
                    throw new ParseError.UNKNOWN_ITEM_TYPE(
                        @"Type '$id' cannot have attributes"
                        );
                }

                line = stream.read_line(null);

                if (line == null)
                {
                    // unexpected end of file
                }

                params = line.split(" ");

                id = params[0];

                while (id != "}")
                {
                    var child_item = read_item(params, stream) as AttributeChild;

                    if (child_item == null)
                    {
                    }

                    parent_item.attach(child_item);

                    line = stream.read_line(null);

                    if (line == null)
                    {
                        // unexpected end of file
                    }

                    params = line.split(" ");

                    id = params[0];
                }

                if (id == "}")
                {
                    line = stream.read_line(null);
                }
            }

            return item;
        }



        /**
         * Read a single iten from the input stream
         *
         * @param params The parameters found on the first line
         * @param stream The input stream located after the first line
         * @return The schematic item read from the stream
         */
        private SchematicItem read_item(string[] params, DataInputStream stream) throws Error, ParseError
        {
            var id = params[0];

            if (!m_types.has_key(id))
            {
                throw new ParseError.UNKNOWN_ITEM_TYPE(
                    @"Unknown item type '$id'"
                    );
            }

            var type = m_types[id];

            var item = Object.@new(type) as SchematicItem;

            return_val_if_fail(item != null, null);

            item.read_with_params(params, stream);

            return item;
        }


        /**
         * A map of the schematic item types
         *
         * The key contains the string that represents the item type
         * in the schematic file.
         *
         * The value contains the type of object to instantiate for
         * the schematic item. This type must derive from
         * SchematicItem.
         */
        private Gee.HashMap<string,Type> m_types;
    }
}
