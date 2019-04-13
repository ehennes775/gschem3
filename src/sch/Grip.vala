namespace Geda3
{
    /**
     *
     */
    public abstract class Grip : Object
    {
        /**
         *
         */
        public abstract void draw(SchematicPainter painter);


        /**
         *
         */
        public abstract void drop(int x, int y);


        /**
         *
         */
        public abstract void grab(int x, int y);


        /**
         *
         */
        public abstract void move(int x, int y);
    }
}
