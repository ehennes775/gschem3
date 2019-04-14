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
        public abstract void draw(
            SchematicPainter painter,
            double half_width
            );


        /**
         *
         */
        public abstract void drop(double x, double y);


        /**
         *
         */
        public abstract void grab(double x, double y);


        /**
         *
         */
        public abstract void move(double x, double y);
    }
}
