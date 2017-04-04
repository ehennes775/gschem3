namespace Geda3
{
    /**
     * A base class for projects
     */
    public abstract class Project : Object
    {
        /**
         * The project file
         *
         * Other files in the project use a relative path from the
         * project file. Moving this file to another folder will break
         * those paths.
         */
        public abstract File file
        {
            get;
            protected set;
        }


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
            protected set;
        }


        /**
         * Save this project
         */
        public abstract void save() throws FileError;
    }
}
