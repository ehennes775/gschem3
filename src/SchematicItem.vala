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
         * a GUI window.
         */
        public signal void invalidate(SchematicItem item);


        /**
         * Calculate the bounds of this object
         *
         * This function does not include the bounds of child attributes
         * int the calculation.
         *
         * @param painter The painter to use for drawing
         * @param reveal Include hidden objects in bounds
         */
        public abstract Bounds calculate_bounds(
            SchematicPainter painter,
            bool reveal
            );


        /**
         * Draw this item using the given painter
         *
         * @param painter The painter to use for drawing
         * @param selected Paint the item as selected
         */
        public abstract void draw(SchematicPainter painter, bool selected);


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
