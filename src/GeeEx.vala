namespace Geda3
{
    /**
     * Extensions for libgee
     */
    namespace GeeEx
    {
        /**
         * Checks if any item in traversible matches the predicate
         *
         * This function will be available in version 19.94 of
         * libgee-0.8.
         *
         * @param trav The traversible with the items to test
         * @param pred The predicate to test items with
         * @return If any item in traversible matches the predicate
         */
        public bool any_match<G>(Gee.Traversable<G> trav, Gee.Predicate<G> pred)
        {
            var result = false;

            trav.foreach((item) =>
            {
                if (pred(item))
                {
                    result = true;
                    return false;
                }

                return true;
            });

            return result;
        }


        /**
         * Checks if only one item in traversible matches the predicate
         *
         * Hopefully, this function will be available in a future
         * version of libgee-0.8.
         *
         * @param trav The traversible with the items to test
         * @param pred The predicate to test items with
         * @return If ony one item in traversible matches the predicate
         */
        public bool one_match<G>(Gee.Traversable<G> trav, Gee.Predicate<G> pred)
        {
            var count = 0;

            trav.foreach((item) =>
            {
                if (pred(item))
                {
                    return ++count <= 1;
                }

                return true;
            });

            return count == 1;
        }
    }
}
