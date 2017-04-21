namespace Geda3
{
    /**
     *
     */
    public abstract class ProjectPersist : Object
    {
        /**
         *
         *
         * @param key The key for the schematic to delete from the
         * project
         */
        public abstract void delete_schematic(string key) throws MapError;
    }
}
