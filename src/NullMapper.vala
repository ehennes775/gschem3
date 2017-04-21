namespace Geda3
{
    /**
     * Provides a mapper that performs no operations
     */
    public class NullMapper : Mapper
    {
        /**
         * {@inheritDoc}
         */
        public override void @delete()
        {
        }


        /**
         * {@inheritDoc}
         */
        public override void update()
        {
        }
    }
}
