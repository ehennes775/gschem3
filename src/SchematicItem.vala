namespace Geda3
{
    /**
     * Base class for items found in schematics or symbols
     */
    public abstract class SchematicItem : Object
    {
        /**
         * Calculate the bounds of this item
         *
         * @param painter The painter to use for bounds calculation
         */
        public abstract Bounds calculate_bounds(SchematicPainter painter);


        /**
         * Draw this item using the given painter
         *
         * @param painter The painter to use for drawing
         */
        public abstract void draw(SchematicPainter painter);


        /**
         * Read this item from the input stream
         *
         * @param stream The input stream to read from
         */
        public abstract void read(DataInputStream stream) throws IOError, ParseError;


        /**
         * Write this item to the output stream
         *
         * @param stream The output stream to write to
         */
        public abstract void write(DataOutputStream stream) throws IOError;
    }
}
