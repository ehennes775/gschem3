namespace Geda3
{
    /**
     * Conversion strategy for path commands
     */
    public interface PathCommandConverter : Object
    {
        /**
         * Convert multiple path lines into path commands
         *
         * @param lines The path string in multiple lines
         * @return The sequence of path commands
         */
        public abstract Gee.List<PathCommand> convert_from_lines(string[] lines) throws ParseError;


        /**
         * Convert a path string into path commands
         *
         * @param path_string The path string
         * @return The sequence of path commands
         */
        public abstract Gee.List<PathCommand> convert_from_string(string path_string) throws ParseError;


        /**
         * Convert path commands in to a path string in multiple lines
         *
         * @param commands The commands to convert to a path string
         * @return The path string in multiple lines
         */
        public abstract string[] convert_to_lines(Gee.List<PathCommand> commands);
    }
}
