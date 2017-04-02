namespace Geda3
{
    /**
     * A base class for projects
     */
    public abstract class Project : Object
    {
        /**
         * A list of the schematics in this project
         *
         * This property is used as a port. To make this property
         * usable as a port, the reference does not change throughout
         * the lifetime of this project object.
         */
        public abstract SchematicList schematic_list
        {
            get;
            construct;
        }
    }
}
