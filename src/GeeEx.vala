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
         * This function will be available in a future revision of
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
    }
}
