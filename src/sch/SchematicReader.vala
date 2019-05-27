namespace Geda3
{
    public class SchematicReader
    {
        /**
         * Create a default schematic reader
         */
        public SchematicReader()
        {
            m_types = new Gee.HashMap<string,CreateFunc>();

            m_types.@set(
                ArcItem.TYPE_ID,
                create_arc
                );

            m_types.@set(
                BoxItem.TYPE_ID,
                create_box
                );

            m_types.@set(
                BusItem.TYPE_ID,
                create_bus
                );

            m_types.@set(
                ComplexItem.TYPE_ID,
                create_complex
                );

            m_types.@set(
                CircleItem.TYPE_ID,
                create_circle
                );

            m_types.@set(
                LineItem.TYPE_ID,
                create_line
                );

            m_types.@set(
                NetItem.TYPE_ID,
                create_net
                );

            m_types.@set(
                PathItem.TYPE_ID,
                create_path
                );

            m_types.@set(
                PinItem.TYPE_ID,
                create_pin
                );

            m_types.@set(
                TextItem.TYPE_ID,
                create_text
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
                    throw new ParseError.UNKEXPECTED_END_OF_FILE(
                        @"Unexpected end of file"
                        );
                }

                params = line.split(" ");

                id = params[0];

                while (id != "}")
                {
                    var child_item = read_item(params, stream) as AttributeChild;

                    if (child_item == null)
                    {
                    throw new ParseError.UNKNOWN_ITEM_TYPE(
                        @"Type '$id' cannot be attached as an attribute"
                        );
                    }

                    parent_item.attach(child_item);

                    line = stream.read_line(null);

                    if (line == null)
                    {
                        throw new ParseError.UNKEXPECTED_END_OF_FILE(
                            @"Unexpected end of file"
                            );
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

            var creator = m_types[id];

            if (creator == null)
            {
                throw new ParseError.UNKNOWN_ITEM_TYPE(
                    @"Unknown item type '$id'"
                    );
            }

            var item = creator();

            return_val_if_fail(item != null, null);

            item.read_with_params(params, stream);

            return item;
        }


        /**
         * 
         */
        [CCode(has_target=false)]
        private delegate SchematicItem CreateFunc();


        // temp located here for development
        private static ComplexLibrary m_library = LibraryStore.get_instance();


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
        private Gee.HashMap<string,CreateFunc> m_types;


        private static SchematicItem create_arc()
        {
            return new ArcItem();
        }


        private static SchematicItem create_box()
        {
            return new BoxItem();
        }


        private static SchematicItem create_bus()
        {
            return new BusItem();
        }


        private static SchematicItem create_complex()
        {
            return new ComplexItem(m_library);
        }


        private static SchematicItem create_circle()
        {
            return new CircleItem();
        }


        private static SchematicItem create_line()
        {
            return new LineItem();
        }


        private static SchematicItem create_net()
        {
            return new NetItem();
        }


        private static SchematicItem create_path()
        {
            return new PathItem();
        }


        private static SchematicItem create_pin()
        {
            return new PinItem();
        }


        private static SchematicItem create_text()
        {
            return new TextItem();
        }
    }
}
