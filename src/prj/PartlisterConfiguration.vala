namespace Geda3
{
    /**
     * An interface for partlister configuration
     */
    public abstract interface PartlisterConfiguraion : Object
    {
        /**
         * Get the partlist export format from the configuration
         *
         * Pass the default value into this function. If the
         * configuration item exists, this function replaces the
         * argument with the value. If the configuration item does
         * not exist, the argument remains unchanged.
         *
         * @param format The partlist export format
         */
        public abstract void retrieve_partlist_export_format(
            ref string format
            );


        /**
         * Set the partlist export format in the configuration
         *
         * @param format The partlist export format
         */
        public abstract void store_partlist_export_format(
            string format
            );
    }
}
