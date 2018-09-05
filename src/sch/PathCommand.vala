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
        public abstract void build_bounds(ref PathContext context, ref Bounds bounds);


        /**
         *
         */
        public abstract void put(PathCommandReceiver receiver);


        /**
         *
         */
        public abstract string to_path_string();
    }
}
