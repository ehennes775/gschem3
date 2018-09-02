namespace Geda3
{
    /**
     * Convert path commands found in the current file format
     */
    public class PathCommandConverter1 : Object, PathCommandConverter
    {
        /**
         * Initialize the instance
         */
        construct
        {
            m_table = new Gee.HashMap<unichar,ConvertFunc>();

            m_table.@set(
                'M',
                ConvertAbsoluteMoveTo
                );

            m_table.@set(
                'm',
                ConvertRelativeMoveTo
                );

            m_table.@set(
                'L',
                ConvertAbsoluteLineTo
                );

            m_table.@set(
                'l',
                ConvertRelativeLineTo
                );

            m_table.@set(
                'Z',
                ConvertClosePath
                );

            m_table.@set(
                'z',
                ConvertClosePath
                );
        }


        /**
         * {@inheritDoc}
         */
        public Gee.List<PathCommand> convert_from_lines(string[] lines) throws ParseError
        {
            var path_string = string.joinv(" ", lines);

            return convert_from_string(path_string);
        }


        /**
         * {@inheritDoc}
         */
        public Gee.List<PathCommand> convert_from_string(string path_string) throws ParseError
        {
            unichar command_id;
            var commands = new Gee.ArrayList<PathCommand>();
            int index = 0;

            var procesing = ParseUtility.parse_command(
                path_string,
                ref index,
                out command_id
                );

            while (procesing)
            {
                var convert = m_table.@get(command_id);

                if (convert == null)
                {
                    throw new ParseError.UNKNOWN_PATH_COMMAND(
                        @"Unknown path command '$(command_id)'"
                        );
                }

                var command_item = convert(path_string, ref index);

                commands.add(command_item);

                procesing = ParseUtility.parse_command(
                    path_string,
                    ref index,
                    out command_id
                    );
            }

            return commands;
        }


        /**
         *
         */
        [CCode (has_target = false)]
        private delegate PathCommand ConvertFunc(string path, ref int index);


        /**
         *
         */
        private Gee.Map<unichar,ConvertFunc> m_table;


        /**
         *
         */
        private static PathCommand ConvertClosePath(string path, ref int index)
        {
            return new ClosePathCommand();
        }


        /**
         *
         */
        private static PathCommand ConvertAbsoluteLineTo(string path, ref int index)
        {
            var x = ParseUtility.parse_param(path, ref index);
            var y = ParseUtility.parse_param(path, ref index);

            return new AbsoluteLineToCommand(x, y);
        }


        /**
         *
         */
        private static PathCommand ConvertAbsoluteMoveTo(string path, ref int index)
        {
            var x = ParseUtility.parse_param(path, ref index);
            var y = ParseUtility.parse_param(path, ref index);

            return new AbsoluteMoveToCommand(x, y);
        }


        /**
         *
         */
        private static PathCommand ConvertRelativeLineTo(string path, ref int index)
        {
            var x = ParseUtility.parse_param(path, ref index);
            var y = ParseUtility.parse_param(path, ref index);

            return new RelativeLineToCommand();
        }


        /**
         *
         */
        private static PathCommand ConvertRelativeMoveTo(string path, ref int index)
        {
            var x = ParseUtility.parse_param(path, ref index);
            var y = ParseUtility.parse_param(path, ref index);

            return new RelativeMoveToCommand();
        }
    }
}
