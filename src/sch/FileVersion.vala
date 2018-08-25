namespace Geda3
{
    /**
     * Functions for operating on coordinates
     */
    public struct FileVersion
    {
        /**
         * The latest file format produced by the gEDA suite
         */
        public const FileVersion LATEST = { "20150930", "2" };


        /**
         * The token that starts the version line in the file format
         */
        public const string VERSION_TOKEN = "v";


        /**
         *
         */
        public string tool_version;


        /**
         *
         */
        public string file_version;


        /**
         * Read the file version from the input stream
         *
         * @param stream The stream to read the version from
         * @throws IOError TBD
         * @throws ParseError TBD
         */
        public static FileVersion read(DataInputStream stream) throws IOError, ParseError
        {
            var input = stream.read_line(null);

            var params = input.split(" ");

            if (params.length != 3)
            {
                throw new ParseError.PARAMETER_COUNT(
                    @"Version has incorrect parameter count"
                    );
            }

            if (params[0] != VERSION_TOKEN)
            {
                throw new ParseError.VERSION_EXPECTED(
                    @"Version line expected"
                    );
            }

            FileVersion version = FileVersion();

            version.tool_version = params[1];

            version.file_version = params[2];

            return version;
        }


        /**
         * Write the file version to the output stream
         *
         * @param stream The stream to write the version to
         * @throws IOError TBD
         */
        public void write(DataOutputStream stream) throws IOError
        {
            var output = "%s %s %s\n".printf(
                VERSION_TOKEN,
                tool_version,
                file_version
                );

            stream.write_all(output.data, null);
        }
    }
}

