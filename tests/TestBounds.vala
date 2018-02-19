namespace GedaTest.Bounds
{
    void check_construct_empty()
    {
        var bounds = Geda3.Bounds();

        assert_true(bounds.empty());

        assert_true(bounds.get_width() == 0);
        assert_true(bounds.get_height() == 0);

        for (var count = 0; count < 100; count++)
        {
            var x = Test.rand_int();
            var y = Test.rand_int();

            assert_true(!bounds.contains(x, y));
        }
    }


    void check_construct_with_points()
    {
        for (var count = 0; count < 100; count++)
        {
            var x0 = Test.rand_int();
            var y0 = Test.rand_int();
            var x1 = Test.rand_int();
            var y1 = Test.rand_int();

            var bounds = Geda3.Bounds.with_points(
                x0,
                y0,
                x1,
                y1
                );

            assert_true(!bounds.empty());

            // the width and height may overflow in this test, so
            // only check if the result is non-zero
            assert_true(bounds.get_width() != 0);
            assert_true(bounds.get_height() != 0);

            assert_true(bounds.contains(x0, y0));
            assert_true(bounds.contains(x0, y1));
            assert_true(bounds.contains(x1, y1));
            assert_true(bounds.contains(x1, y0));
        }
    }


    void check_construct_with_fpoints()
    {
        for (var count = 0; count < 100; count++)
        {
            var x0 = Test.rand_double();
            var y0 = Test.rand_double();
            var x1 = Test.rand_double();
            var y1 = Test.rand_double();

            var bounds = Geda3.Bounds.with_fpoints(
                x0,
                y0,
                x1,
                y1
                );

            assert_true(!bounds.empty());

            // the width and height may overflow in this test, so
            // only check if the result is non-zero
            assert_true(bounds.get_width() != 0);
            assert_true(bounds.get_height() != 0);

            int x[] =
            {
                (int) Math.floor(x0),
                (int) Math.ceil(x0),
                (int) Math.floor(x1),
                (int) Math.ceil(x1)
            };

            int y[] =
            {
                (int) Math.floor(y0),
                (int) Math.ceil(y0),
                (int) Math.floor(y1),
                (int) Math.ceil(y1)
            };

            for (var xi = 0; xi < x.length; xi++)
            {
                for (var yi = 0; yi < y.length; yi++)
                {
                    assert_true(bounds.contains(x[xi], y[yi]));
                }
            }
        }
    }


    void check_expand()
    {
        for (var count = 0; count < 100; count++)
        {
            var bounds = Geda3.Bounds.with_points(
                Test.rand_int_range(int.MIN + 1, int.MAX),
                Test.rand_int_range(int.MIN + 1, int.MAX),
                Test.rand_int_range(int.MIN + 1, int.MAX),
                Test.rand_int_range(int.MIN + 1, int.MAX)
                );

            assert_true(!bounds.contains(bounds.min_x, bounds.min_y - 1));
            assert_true(!bounds.contains(bounds.min_x - 1, bounds.min_y));

            assert_true(!bounds.contains(bounds.max_x, bounds.max_y + 1));
            assert_true(!bounds.contains(bounds.max_x + 1, bounds.max_y));

            assert_true(!bounds.contains(bounds.min_x, bounds.max_y + 1));
            assert_true(!bounds.contains(bounds.min_x - 1, bounds.max_y));

            assert_true(!bounds.contains(bounds.max_x, bounds.min_y - 1));
            assert_true(!bounds.contains(bounds.max_x + 1, bounds.min_y));

            var bounds2 = bounds;
            bounds2.expand(1, 1);

            assert_true(bounds2.contains(bounds.min_x, bounds.min_y - 1));
            assert_true(bounds2.contains(bounds.min_x - 1, bounds.min_y));

            assert_true(bounds2.contains(bounds.max_x, bounds.max_y + 1));
            assert_true(bounds2.contains(bounds.max_x + 1, bounds.max_y));

            assert_true(bounds2.contains(bounds.min_x, bounds.max_y + 1));
            assert_true(bounds2.contains(bounds.min_x - 1, bounds.max_y));

            assert_true(bounds2.contains(bounds.max_x, bounds.min_y - 1));
            assert_true(bounds2.contains(bounds.max_x + 1, bounds.min_y));
        }
    }


    void check_expand_empty()
    {
        for (var count = 0; count < 100; count++)
        {
            var bounds = Geda3.Bounds();

            assert_true(bounds.empty());

            var x = Test.rand_int_range(0, int.MAX);
            var y = Test.rand_int_range(0, int.MAX);

            bounds.expand(x, y);

            assert_true(bounds.empty());
        }
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/bounds/constructempty", check_construct_empty);
        Test.add_func("/geda/libgeda/bounds/constructwithpoints", check_construct_with_points);
        Test.add_func("/geda/libgeda/bounds/constructwithfpoints", check_construct_with_fpoints);
        Test.add_func("/geda/libgeda/bounds/expandempty", check_expand_empty);
        Test.add_func("/geda/libgeda/bounds/expand", check_expand);

        return Test.run();
    }
}
