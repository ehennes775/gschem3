namespace Geda3
{
    /**
     *
     */
    public abstract interface StandardPromoterConfiguration : Object
    {
        public abstract bool retrieve_promote_invisible();


        public abstract Gee.Set<string> retrieve_promote_attributes();
    }
}
