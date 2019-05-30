namespace Geda3
{
    /**
     *
     */
    public abstract interface ComplexLibrary : Object
    {
        /**
         * @return The symbol from the library or null if not found
         */
        public abstract ComplexSymbol? @get(string name);
    }
}
