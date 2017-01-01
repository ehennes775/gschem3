namespace Geda3
{
    /**
     * Functions for operating on angles
     */
    namespace Angle
    {
        /**
         * Checks if an angle is [0,360)
         *
         * @param angle the angle in degrees
         * @retval TRUE if the angle is [0,360)
         */
        public bool is_normal(int angle)
        {
            return ((0 <= angle) && (angle < 360));
        }


        /**
         * Checks if an angle is orthographic
         *
         * @param angle the angle in degrees
         * @retval TRUE if the angle is a multiple of 90 degrees
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
    }
}


