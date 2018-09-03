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
        public abstract void put(PathCommandReceiver receiver);


        /**
         *
         */
        public abstract string to_path_string();
    }
}
