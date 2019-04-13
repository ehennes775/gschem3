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
        public abstract void build_grips(
            GripAssistant assistant,
            Gee.List<Grip> grips
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
        public abstract string to_path_string();


        /**
         *
         */
        public abstract void translate(int dx, int dy);
    }
}
