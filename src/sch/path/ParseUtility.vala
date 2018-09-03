namespace Geda3
{
    /**
     * Functions for parsing path strings
     */
    namespace ParseUtility
    {
        /**
         * Parse the next command from a path string 
         * 
         * @param path The path string
         * @param index The index of the character following the path
         * command.
         * @param command The path command. This output parameter is
         * only valid when this function returns true.
         * @return Returning true indicated processing should continue.
         * Returning false indacates a command was not found and
         * processing should stop.
         */
        public bool parse_command(string path, ref int index, out unichar command) throws ParseError
        {
            var success = skip_whitespace(path, ref index);

            if (success)
            {
                success = path.get_next_char(ref index, out command);
            }

            if (success && !command.isalpha())
            {
                throw new ParseError.EXPECTING_PATH_COMMAND(
                    @"Expecting path command '$(command)'"
                    );
            }

            return success;
        }


        /**
         * Parse the next parameter from a path string
         *
         * @param path The path string
         * @param index The index of the character following the 
         * parameter.
         * @return The value of the parameter.
         */
        public int parse_param(string path, ref int index) throws ParseError
        {
            unichar current = 'x';    // assignment eliminates warning
            var success = skip_whitespace(path, ref index);
            var index0 = index;

            if (success)
            {
                success = path.get_next_char(ref index, out current);
            }

            if (!success)
            {
                throw new ParseError.EXPECTING_PATH_PARAMETER(
                    "Expecting path parameter"
                    );
            }

            if (current == ',')
            {
                success = skip_whitespace(path, ref index);

                if (success)
                {
                    success = path.get_next_char(ref index, out current);
                }

                if (!success)
                {
                    throw new ParseError.EXPECTING_PATH_PARAMETER(
                        "Expecting path parameter"
                        );
                }
            }

            if (current == '-')
            {
                success = path.get_next_char(ref index, out current);

                if (!success)
                {
                    throw new ParseError.EXPECTING_PATH_PARAMETER(
                        "Expecting path parameter"
                        );
                }
            }

            var index1 = index;

            while (success && current.isdigit())
            {
                index1 = index;

                success = path.get_next_char(ref index, out current);
            }

            return Coord.parse(
                path.substring(index0, index1 - index0)
                );
        }


        /**
         * Skip past whitespace
         *
         * @param path The path string
         * @param index The byte index of the non-whitespace character
         * @return Returning true indicates a non-whitespace character
         * was found. Returning false indicates the end of the string
         * was reached.
         */
        private bool skip_whitespace(string path, ref int index)
        {
            if (index < path.length)
            {
                unichar current;
                var temp_index = index;
                var success = path.get_next_char(ref temp_index, out current);

                while (success)
                {
                    if (!current.isspace())
                    {
                        return true;
                    }

                    index = temp_index;
                    success = path.get_next_char(ref temp_index, out current);
                }
            }

            return false;
        }
    }
}
