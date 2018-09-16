namespace Geda3
{
    /**
     * Base class for items found in schematics or symbols
     */
    public abstract class SchematicItem : Object
    {
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
         * Calculate the bounds of this object
         *
         * @param painter The painter to use for bounds calculation
         * @param reveal Include invisible items in bounds calculation
         */
        public abstract Bounds calculate_bounds(
            SchematicPainter painter,
            bool reveal
            );


        /**
         * Draw this item using the given painter
         *
         * @param painter The painter to use for drawing
         * @param reveal Draw invisible items
         * @param selected Paint the item as selected
         */
        public abstract void draw(
            SchematicPainter painter,
            bool reveal,
            bool selected
            );


        /**
         * Draw this item using the given painter
         *
         * @param painter The painter to use for drawing
         * @param selected Paint the item as selected
         */
        public abstract void invalidate_on(Invalidatable invalidatable);


        /**
         * Read this item from the input stream
         *
         * @param stream The input stream to read from
         */
        public virtual void read(DataInputStream stream) throws IOError, ParseError
        {
            var input = stream.read_line(null);

            var params = input.split(" ");

            read_with_params(params, stream);
        }


        /**
         * Read this item from the input stream
         *
         * @param params 
         * @param stream The input stream to read from
         */
        public abstract void read_with_params(string[] params, DataInputStream stream) throws IOError, ParseError;


        /**
         * Write this item to the output stream
         *
         * @param stream The output stream to write to
         */
        public abstract void write(DataOutputStream stream) throws IOError;
    }
}
