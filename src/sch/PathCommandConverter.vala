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
    }
}
