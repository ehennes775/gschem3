namespace Gschem3
{
    /**
     * Selects complex items for the complex drawing tool
     */
    public abstract interface ComplexSelector : Object
    {
        /**
         * Indicated the user has selected a different symbol
         *
         * This signal indicates the user indends to place a symbol
         * and the GUI should prepare for a symbol placement.
         */
        public signal void symbol_changed();


        /**
         * This signal indicates changes to the complex item and
         * listeners should recreate to pick up the changes.
         *
         * When this signal is emitted, the user may or may not intend
         * to place a symbol. The GUI should not make state changes
         * that are based on user intent.
         */
        public signal void recreate_symbol();
 

        /**
         * The name of the complex item from the library
         */
        public abstract string? symbol_name
        {
            get;
            construct set;
        }


        /**
         * Create a new complex item
         *
         * This function could return null in the case of a failure.
         * 
         * \return A new complex item to place
         */
        public abstract Geda3.ComplexItem? create_symbol();
    }
}
