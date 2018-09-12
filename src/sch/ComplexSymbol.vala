namespace Geda3
{
    /**
     *
     */
    public class ComplexSymbol : Object
    {
        /**
         *
         */
        public Schematic schematic
        {
            get;
            construct;
        }


        /**
         *
         */
        public ComplexSymbol(Schematic schematic)
        {
            Object(
                schematic : schematic
                );
        }


        /**
         *
         */
        public void draw(
            int x,
            int y,
            SchematicPainter painter,
            bool reveal,
            bool selected
            )
        {
            if (schematic != null)
            {
                painter.draw_items(x, y, 0, false, schematic.items);
            }
        }
    }
}
