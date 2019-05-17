namespace Geda3
{
    public class Schematic : Object
    {
        /**
         * A signal inicating an attriubte has changed
         *
         * @param child The attribute that changed
         * @param parent The attribute parent object
         */
        public signal void attribute_changed(
            AttributeChild child,
            AttributeParent parent
            );


        /**
         * A signal requesting an item be redrawn
         *
         * This signal is emitted when an item needs to be redrawn in
         * a GUI window. Schematic items forward requests from their
         * child attributes.
         *
         * Schematic items that change geometrically send two requests.
         * First request for invalidaton is at the old location and the
         * bounds for it must be calculated immediately and added to
         * the invalid region. Second request is at the new location.
         *
         * When not changing geometrically, one request may be sent.
         * For example, changing the color will not change which pixels
         * make up the item, so only one request is sent.
         *
         * @param item The schemaitc item requesting to be redrawn
         */
        public signal void invalidate(SchematicItem item);


        /**
         * A read only view of the items in the schematic
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
            var success = m_items.add(item);

            if (success)
            {
                item.attribute_changed.connect(on_attribute_changed);
                item.invalidate.connect(on_invalidate);
            }

            return success;
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
         * Find the closest item the the given coordinates
         *
         * @param painter The painter to use for calculations
         * @param x The x coordinate of the point
         * @param y The y coordinate of the point
         * @param max_distance The maximum distance for items
         * @return The closest item or null if none
         */
        public SchematicItem? closest_item(
            SchematicPainter painter,
            int x,
            int y,
            double max_distance
            )
        {
            var closest_distance = max_distance;
            SchematicItem? closest_item = null;

            foreach (var item in m_items)
            {
                var item_distance = item.shortest_distance(
                    painter,
                    x,
                    y
                    );
                
                if (item_distance < closest_distance)
                {
                    closest_distance = item_distance;
                    closest_item = item;
                }
            }

            return closest_item;
        }


        /**
         * Draw the schematic
         *
         * @param painter The painter to use for drawing
         * @param selected A set of the selected items
         * @param reveal Draw invisible items
         */
        public void draw(
            SchematicPainter painter,
            Gee.Set<SchematicItem> selected,
            bool reveal
            )

            requires(m_items != null)

        {
            foreach (var item in m_items)
            {
                item.draw(painter, reveal, item in selected);
            }
        }


        /**
         * Locate an insertion point for the items in this schematic
         *
         * @param x The x coordinate of the insertion point
         * @param y The y coordinate of the insertion point
         * @return True, if the function was able to get coordinates
         */
        public bool locate_insertion_point(out int x, out int y)

            requires(m_items != null)
            requires(m_items.all_match(i => i != null))

        {
            var success = false;
            var temp_x = int.MAX;
            var temp_y = int.MAX;

            foreach (var item in m_items)
            {
                int item_x;
                int item_y;

                var item_success = item.locate_insertion_point(
                    out item_x,
                    out item_y
                    );

                if (item_success)
                {
                    temp_x = int.min(temp_x, item_x);
                    temp_y = int.min(temp_y, item_y);

                    success = true;
                }
            }

            x = temp_x;
            y = temp_y;

            return success;
        }


        /**
         * Get all the items that intersect the box
         *
         * @param painter The painter to use for calculations
         * @param box The box to test for intersection
         * @return A set of items that intersect the box
         */
        public Gee.Set<SchematicItem> intersected_items(
            SchematicPainter painter,
            Bounds box
            )

            requires(m_items != null)

        {
            var x = new Gee.HashSet<SchematicItem>();

            foreach (var item in m_items)
            {
                if (item.intersects_box(painter, box))
                {
                    x.add(item);
                }
            }

            return x;
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
         * Read a schematic from an input file asynchronously
         *
         * @param file the file to read the schematic from
         * @param cancel a token to cancel a read in progress
         * @throws Error TBD
         */
        public async void read_from_file_async(File file, Cancellable? cancel = null) throws Error
        {
            var stream = new DataInputStream(file.read());

            yield read_async(stream, cancel);
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

            var line = stream.read_line();

            while (line != null)
            {
                var item = reader.read(ref line, stream);

                add(item);
            }
        }


        /**
         * Read a schematic from an input stream asyncronously
         *
         * @param stream the stream to read the schematic from
         * @param cancel a token to cancel a read in progress
         * @throws Error TBD
         */
        public async void read_async(DataInputStream stream, Cancellable? cancel = null) throws Error

            requires(m_items != null)

        {
            m_items.clear();

            version = FileVersion.read(stream);

            var line = yield stream.read_line_async(
                Priority.DEFAULT,
                cancel
                );

            while (line != null)
            {
                // ran into code generation issues with an asyncronous
                // version of this function. The output c code has an
                // undeclared itentifier for the line varaible.
                var item = reader.read(ref line, stream);

                add(item);
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


        /**
         * Forward the signal when an attribute changes
         *
         * @param child The attribute that changed
         * @param parent The attribute parent object
         */
        private void on_attribute_changed(
            AttributeChild child,
            AttributeParent parent
            )
        {
            attribute_changed(child, parent);
        }


        private void on_invalidate(SchematicItem item)
        {
            invalidate(item);
        }
    }
}
