namespace Geda3
{
    /**
     * An abstract base class for PathItem commands
     */
    public abstract class PathCommand : Object
    {
        /**
         *
         */
        public abstract void advance_context(ref PathContext context);


        /**
         * Include the bounds of this path command in the overall
         * path bounds calculation
         *
         * @param context
         * @param bounds
         */
        public abstract void build_bounds(
            ref PathContext context,
            ref Bounds bounds
            );


        /**
         *
         */
        public abstract void build_grips(
            GripAssistant assistant,
            PathItem parent,
            int command_index,
            Gee.List<Grip> grips
            );


        /**
         *
         */
        public abstract void get_point(
            ref PathContext context,
            int index,
            out int x,
            out int y
            );


        /**
         * Determine an insertion point from this path command
         *
         * @param context
         * @param x The x coordinate of the insertion point
         * @param y The y coordinate of the insertion point
         * @return True, if the function was able to get coordinates
         */
        public abstract bool locate_insertion_point(
            ref PathContext context,
            out int x,
            out int y
            );


        /**
         *
         */
        public abstract void mirror_x(int cx);


        /**
         *
         */
        public abstract void mirror_y(int cy);


        /**
         *
         */
        public abstract void put(PathCommandReceiver receiver);


        /**
         *
         */
        public abstract void rotate(int cx, int cy, int angle);


        /**
         *
         */
        public abstract void set_point(
            ref PathContext context,
            int index,
            int x,
            int y
            );


        /**
         * Include the shortest distance of this path command in the
         * overall shortest distance calcuation
         *
         * @param context
         * @param x The x coordinate of the point
         * @param y The y coordinate of the point
         * @return The shortest distance between the point and this
         * command
         */
        public abstract double shortest_distance(
            ref PathContext context,
            int x,
            int y
            );


        /**
         *
         */
        public abstract string to_path_string();


        /**
         *
         */
        public abstract void translate(int dx, int dy);
    }
}
