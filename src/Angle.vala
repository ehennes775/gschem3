namespace Geda3
{
    /**
     * Functions for operating on angles
     */
    namespace Angle
    {
        /**
         * Convert radians to degrees
         *
         * @param radians the angle in radians
         * @return the angle in degrees
         */
        public int from_radians(double radians)
        {
            return (int) Math.round(180.0 * radians / Math.PI);
        }


        /**
         * Checks if an angle is [0,360)
         *
         * @param angle the angle in degrees
         * @return TRUE if the angle is [0,360)
         */
        public bool is_normal(int angle)
        {
            return ((0 <= angle) && (angle < 360));
        }


        /**
         * Checks if an angle is orthographic
         *
         * @param angle the angle in degrees
         * @return TRUE if the angle is a multiple of 90 degrees
         */
        public bool is_ortho(int angle)
        {
            return ((angle % 90) == 0);
        }


        /**
         * Make an angle orthographic
         *
         * Snaps the angle to the nearest 90 degrees
         *
         * @param angle the angle in degrees
         * @return the orthographic angle
         */
        public int make_ortho (int angle)
        {
           return (int)Math.round(angle / 90.0) * 90;
        }


        /**
         * Normalize an angle to [0,360)
         *
         * @param angle the angle in degrees
         * @return the normalized angle inside [0,360)
         */
        public int normalize(int angle)
        {
          if (angle < 0)
          {
              angle = 360 - (-angle % 360);
          }
          if (angle >= 360)
          {
              angle %= 360;
          }

          return angle;
        }


        /**
         * Parse the string representation of an angle
         *
         * @param input the string representation of the angle
         * @return the angle
         * @throws ParseError.INVALID_INTEGER not a valid number
         * @throws ParseError.OUT_OF_RANGE input outside 32 bit integer
         */
        public int parse(string input) throws ParseError
        {
            int64 result;

            var success = int64.try_parse(input, out result);

            if (!success)
            {
                throw new ParseError.INVALID_INTEGER(
                    @"Invalid angle: $input"
                    );
            }

            if ((result < int.MIN) || (result > int.MAX))
            {
                throw new ParseError.OUT_OF_RANGE(
                    @"Angle out of range: $input"
                    );
            }

            return (int) result;
        }


        /**
         * Convert degrees to radians
         *
         * @param angle the angle in degrees
         * @return the angle in radians
         */
        public double to_radians(int angle)
        {
            return Math.PI * angle / 180.0;
        }
    }
}
