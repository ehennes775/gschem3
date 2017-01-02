namespace Geda3
{
    /**
     * Represents a net on a schematic
     */
    public class SchematicItemNet
    {
        /**
         *
         */
        public const string TYPE_ID = "N";


        /**
         *
         */
        public SchematicItemNet()
        {
            b_x[0] = 0;
            b_x[1] = 0;
            b_y[0] = 0;
            b_y[1] = 0;
            b_color = Color.NET;
        }


        /**
         *
         */
        public void read(DataInputStream stream) throws IOError, ParseError
        {
            var input = stream.read_line(null);
            stdout.printf("read: '%s'\n", input);

            var params = input.split(" ");

            foreach (var param in params)
            {
                stdout.printf("    param: '%s'\n", param);
            }

            stdout.flush();

            if (params.length != 6)
            {
                throw new ParseError.PARAMETER_COUNT(
                    @"Net with incorrect parameter count"
                    );
            }

            return_if_fail(params[0] == TYPE_ID);

            b_x[0] = Coord.parse(params[1]);
            b_y[0] = Coord.parse(params[2]);
            b_x[1] = Coord.parse(params[3]);
            b_y[1] = Coord.parse(params[4]);
            b_color = Color.parse(params[5]);
        }


        /**
         *
         *
         */
        public void write(DataOutputStream stream) throws IOError
        {
            var output = "%s %d %d %d %d %d\n".printf(
                TYPE_ID,
                b_x[0],
                b_y[0],
                b_x[1],
                b_y[1],
                b_color
                );

            stdout.printf("write: '%s'\n", output);
            stdout.flush();

            stream.write_all(output.data, null);
        }


        /**
         * Backing store the color
         *
         * Temporarily public for testing
         */
        public int b_color;


        /**
         * Backing store the x coordinates
         *
         * Temporarily public for testing
         */
        public int b_x[2];


        /**
         * Backing store the y coordinates
         *
         * Temporarily public for testing
         */
        public int b_y[2];
    }
}
