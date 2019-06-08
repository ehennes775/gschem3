namespace Geda3
{
    /**
     * An interface for netlister configuration
     */
    public abstract interface NetlisterConfiguraion : Object
    {
        /**
         * Get the netlist export format from the configuration
         *
         * Pass the default value into this function. If the
         * configuration item exists, this function replaces the
         * argument with the value. If the configuration item does
         * not exist, the argument remains unchanged.
         *
         * @param format The netlist export format
         */
        public abstract void retrieve_netlist_export_format(
            ref string format
            );


        /**
         * Set the netlist export format in the configuration
         *
         * @param format The netlist export format
         */
        public abstract void store_netlist_export_format(
            string format
            );
    }
}
