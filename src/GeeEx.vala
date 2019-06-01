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
         * @return If only one item in traversible matches the predicate
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


        /**
         * Returns the only one item matching the predicate, or null
         *
         * If one item matches the predicate, this function returns
         * that item. If no item matches the predicate, or two or more
         * items match the predicate, thif function returns null.
         *
         * @param trav The traversible with the items to test
         * @param pred The predicate to test items with
         * @return The one item in traversible matching the predicate
         */
        public G single_match<G>(Gee.Traversable<G> trav, Gee.Predicate<G> pred)
        {
            G? single = null;

            trav.foreach((item) =>
            {
                if (pred(item))
                {
                    if (single != null)
                    {
                        single = null;

                        return false;
                    }

                    single = item;
                }

                return true;
            });

            return single;
        }
    }
}
