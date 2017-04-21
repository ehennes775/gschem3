namespace Geda3
{
    /**
     * Maps a domain object to a database
     */
    public abstract class Mapper
    {
        /**
         * Deletes the mapped domain object from the database
         */
        public abstract void @delete();


        /**
         * Updates the database with data from the mapped domain object
         */
        public abstract void update();
    }
}
