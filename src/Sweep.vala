namespace Geda3
{
    /**
     * Functions for operating on angles
     */
    namespace Sweep
    {
        /**
         * Calculate the sweep between two angles
         *
         * Calculates the sweep from a0, counterclockwise to a1.
         *
         * @param a0 The starting angle
         * @param a1 The ending angle
         */
        public int from_angles(int a0, int a1)

            ensures(result > 0)
            ensures(result <= 360)

        {
            var na0 = Angle.normalize(a0);
            var na1 = Angle.normalize(a1);

            var sweep = na1 - na0;

            if (sweep <= 0)
            {
                sweep += 360;
            }

            return sweep;
        }


        /**
         * Checks if the given sweep is counterclockwise
         *
         * Positive sweeps are clockwise. A sweep angle of 0 is
         * considered counterclockwise.
         *
         * @param sweep The sweep to check
         * @return If the sweep is counterclockwise
         */
        public bool is_counterclockwise(int sweep)
        {
            return (sweep >= 0);
        }


        /**
         * Checks if the given sweep is normal
         *
         * Normal sweeps are in the interval [-360,360]. 
         *
         * @param sweep The sweep to check
         * @return If the sweep is normal
         */
        public bool is_normal(int sweep)
        {
            return ((sweep >= -360) && (sweep <= 360));
        }


        /**
         * Normalize a sweep angle
         *
         * Normal sweeps are in the interval [-360,360]. 
         *
         * @param sweep The sweep to normalize
         * @return The normalized sweep
         */
        public int normalize(int sweep)

            ensures(is_normal(result))

        {
            return sweep.clamp(-360, 360);
        }


        /**
         * Reverse the direction of a sweep
         *
         * This function provides an alternate form of an arc for
         * drawing operations.
         *
         * This function reverses the direction of the sweep. Both
         * starting angle and ending angle would remain the same. If
         * the input sweep is counterclockwise (positive), the returned
         * sweep will be clockwise (negative). Similarly, if the input
         * sweep is clockwise, the returned sweep will be
         * counterclockwise.
         *
         * Sweeps of -360, 0, and 360 are handled as special cases. The
         * function does not return a sweep of 0, which would result in
         * a degenrate arc.
         *
         * ||''Argument''||''Result''||
         * ||(-inf,-360]||360||
         * ||[-359,-1]||argument + 360||
         * ||0||360||
         * ||[1,359]||argument - 360||
         * ||[360,+inf)||-360||
         *
         * @param sweep The sweep angle
         * @return The sweep in the opposite direction
         */
        public int reverse(int sweep)

            ensures(is_normal(result))

        {
            if (sweep <= -360)
            {
                return 360;
            }
            else if (sweep <= 0)
            {
                return sweep + 360;
            }
            else if (sweep >= 360)
            {
                return -360;
            }
            else if (sweep > 0)
            {
                return sweep - 360;
            }
            else
            {
                return_val_if_reached(360);
            }
        }
    }
}
