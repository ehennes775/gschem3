namespace Gschem3
{
    /**
     * An abstract base class representing the editing state of a row
     */
    public abstract class AttributeState : Object
    {
        /**
         * The name of the attribute
         */
        public abstract string name
        {
            get;
            set;
        }


        /**
         * Indicates this row is requesting removal
         *
         * Rows representing temporary states use this property to
         * indicate that the usefullness of the row is done.
         */
        public abstract bool request_removal
        {
            get;
        }


        /**
         * The value of the attribute
         */
        public abstract string @value
        {
            get;
            set;
        }
    }
}
