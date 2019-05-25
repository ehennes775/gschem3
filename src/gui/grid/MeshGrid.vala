namespace Gschem3
{
    /**
     *
     */
    public class MeshGrid : Grid
    {
        /**
         * The line width for drawing grid lines in pixels
         */
        public double grid_line_width
        {
            get;
            set;
            default = 1.0;
        }


        /**
         * The color index to use for major grid lines
         */
        public int major_grid_color
        {
            get;
            set;
            default = Geda3.Color.MAJOR_GRID;
        }


        /**
         * The color index to use for minor grid lines
         */
        public int minor_grid_color
        {
            get;
            set;
            default = Geda3.Color.MINOR_GRID;
        }


        /**
         * Initialize the instance
         */
        construct
        {
        }


        /**
         *
         */
        public MeshGrid()
        {
        }


        /**
         * {@inheritDoc}
         */
        public override void draw(
            Cairo.Context context,
            Geda3.ColorScheme scheme,
            int grid_index
            )
        {
            context.save();

            context.set_line_width(calculate_width(context));

            double x[2];
            double y[2];

            context.clip_extents(out x[0], out y[0], out x[1], out y[1]);

            var min_x = double.min(x[0], x[1]);
            var min_y = double.min(y[0], y[1]);
            var max_x = double.max(x[0], x[1]);
            var max_y = double.max(y[0], y[1]);

            var grid_size = GridSize.grid_size(grid_index);

            var min_xc = (int)Math.ceil(min_x / grid_size);
            var min_yc = (int)Math.ceil(min_y / grid_size);
            var max_xc = (int)Math.floor(max_x / grid_size);
            var max_yc = (int)Math.floor(max_y / grid_size);

            // Draw the minor grid lines

            for (var xc = min_xc; xc <= max_xc; xc++)
            {
                if ((xc % 5) != 0)
                {
                    context.move_to(grid_size * xc, min_y);
                    context.line_to(grid_size * xc, max_y);
                }
            }

            for (var yc = min_yc; yc <= max_yc; yc++)
            {
                if ((yc % 5) != 0)
                {
                    context.move_to(min_x, grid_size * yc);
                    context.line_to(max_x, grid_size * yc);
                }
            }

            var minor_color = scheme[minor_grid_color];

            context.set_source_rgba(
                minor_color.red,
                minor_color.green,
                minor_color.blue,
                minor_color.alpha
                );

            context.stroke();

            // Draw the major grid lines

            for (var xc = min_xc; xc <= max_xc; xc++)
            {
                if (((xc % 5) == 0) && (xc != 0))
                {
                    context.move_to(grid_size * xc, min_y);
                    context.line_to(grid_size * xc, max_y);
                }
            }

            for (var yc = min_yc; yc <= max_yc; yc++)
            {
                if (((yc % 5) == 0) && (yc != 0))
                {
                    context.move_to(min_x, grid_size * yc);
                    context.line_to(max_x, grid_size * yc);
                }
            }

            var major_color = scheme[major_grid_color];

            context.set_source_rgba(
                major_color.red,
                major_color.green,
                major_color.blue,
                major_color.alpha
                );

            context.stroke();

            // Draw grid lines at the origin

            context.move_to(min_x, 0.0);
            context.line_to(max_x, 0.0);
            context.move_to(0.0, min_y);
            context.line_to(0.0, max_y);

            // The origin grid color does not have a standardized index yet

            context.set_source_rgba(
                0.25,
                0.25,
                0.25,
                1.0
                );

            context.stroke();

            context.restore();
        }


        /**
         * Calculate the line width for grid lines
         *
         * @param context The cairo context
         * @return The line width in user coordinates
         */
        public double calculate_width(Cairo.Context context)
        {
            var dx = grid_line_width;
            var dy = grid_line_width;

            context.device_to_user_distance(ref dx, ref dy);

            dx = Math.fabs(dx);
            dy = Math.fabs(dy);

            return double.max(dx, dy);
        }
    }
}
