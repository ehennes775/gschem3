namespace Geda3
{
    /**
     * An abstract base class for schematic symbol libraries
     */
    public abstract class SymbolLibrary
    {
        /**
         * Add a symbol folder to the library
         *
         * @param library The folder to add to the library
         */
        public abstract bool add(File library);
    }
}
