namespace Gschem3
{
    /**
     *
     */
    namespace GridSize
    {
        /**
         *
         */
        public const int DEFAULT = 2;


        /**
         *
         */
        public const int MAX = 12;


        /**
         *
         */
        public const int MIN = 0;


        /**
         *
         */
        public double grid_size(int index)
        {
            return 100.0 * Math.exp2(
                index.clamp(MIN, MAX) - 2
                );
        }


        /**
         *
         */
        public int scale_down(int index)
        {
            return (index - 1).clamp(MIN, MAX);
        }


        /**
         *
         */
        public int scale_up(int index)
        {
            return (index + 1).clamp(MIN, MAX);
        }
    }
}
