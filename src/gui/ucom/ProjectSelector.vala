namespace Gschem3
{
    /**
     *
     */
    public interface ProjectSelector : Object
    {
        /**
         *
         */
        public abstract Geda3.Project? project
        {
            get;
            protected construct set;
        }
    }
}
