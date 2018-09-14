namespace Gschem3
{
    /**
     * Creates complex items for the complex drawing tool
     */
    public abstract class ComplexFactory : Object
    {
        /**
         * This signal indicates changes to the complex item and
         * listeners should recreate to pick up the changes.
         */
        public signal void recreate();
 

        /**
         * The name of the complex item from the library
         */
        public abstract string name
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
        public abstract Geda3.ComplexItem? create();
    }
}
