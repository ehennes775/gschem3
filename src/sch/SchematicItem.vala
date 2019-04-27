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
         * Calculate the bounds of this schematic item
         *
         * This bounds calculation does not include child attributes.
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
         * Check if this item intersects a box
         *
         * @param painter The painter to use for calculations
         * @param box The box to test for intersection
         * @return True if this item intersects the box
         */
        public abstract bool intersects_box(
            SchematicPainter painter,
            Bounds box
            );


        /**
         * Draw this item using the given painter
         *
         * @param painter The painter to use for drawing
         * @param selected Paint the item as selected
         */
        public abstract void invalidate_on(Invalidatable invalidatable);


        /**
         * Mirror the item and child attributes along the x axis
         *
         * This function emits the invalidate signal twice for this
         * item and twice for every child attribute.
         *
         * @param cx
         */
        public abstract void mirror_x(int cx);


        /**
         * Mirror the item and child attributes along the y axis
         *
         * This function emits the invalidate signal twice for this
         * item and twice for every child attribute.
         *
         * @param cy
         */
        public abstract void mirror_y(int cy);


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
         * Rotate this item and its child attributes
         *
         * This function emits the invalidate signal twice for this
         * item and twice for every child attribute.
         *
         * Not all items support arbitrary rotation. In these cases,
         * the angle specified must be orthagonal.
         *
         * @param cx The x coordinate of the center of rotation
         * @param cy The y coordinate of the center of rotation
         * @param angle The angle to rotate the item
         */
        public abstract void rotate(int cx, int cy, int angle);


        /**
         * Calculate the shortest distance from the point to the item
         *
         * @param painter The painter to use for calculations
         * @param x The x coordinate of the point
         * @param y The y coordinate of the point
         * @return The shortest distance from the point to the item
         */
        public abstract double shortest_distance(
            SchematicPainter painter,
            int x,
            int y
            );


        /**
         * Translate this item and its child attributes
         *
         * This function emits the invalidate signal twice for this
         * item and twice for every child attribute.
         * 
         * @param dx The displacement on the x axis
         * @param dy The displacement on the y axis
         */
        public abstract void translate(int dx, int dy);


        /**
         * Write this item to the output stream
         *
         * @param stream The output stream to write to
         */
        public abstract void write(DataOutputStream stream) throws IOError;
    }
}
