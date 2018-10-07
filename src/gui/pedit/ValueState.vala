namespace Gschem3
{
    /**
     *
     */
    public enum ValueState
    {
        /**
         *
         */
        UNAVAILABLE,


        /**
         *
         */
        INCONSISTENT,


        /**
         *
         */
        AVAILABLE,


        /**
         *
         */
        COUNT;


        /**
         *
         */
        public bool is_available()
        {
            return this == AVAILABLE;
        }


        /**
         *
         */
        public bool is_sensitive()
        {
            return this != UNAVAILABLE;
        }
    }
}
