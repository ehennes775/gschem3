namespace GedaTest.Angle
{
    void check_construct_empty()
    {
        Geda3.Bounds bounds = Geda3.Bounds();

        assert_true(bounds.empty());

        for (int count = 0; count < 100; count++)
        {
            int x = Test.rand_int();
            int y = Test.rand_int();

            assert_true(!bounds.contains(x, y));
        }
    }


    void check_construct_with_points()
    {
        for (int count = 0; count < 100; count++)
        {
            int x0 = Test.rand_int();
            int y0 = Test.rand_int();
            int x1 = Test.rand_int();
            int y1 = Test.rand_int();

            Geda3.Bounds bounds = Geda3.Bounds.with_points(
                x0,
                y0,
                x1,
                y1
                );

            assert_true(!bounds.empty());

            assert_true(bounds.contains(x0, y0));
            assert_true(bounds.contains(x0, y1));
            assert_true(bounds.contains(x1, y1));
            assert_true(bounds.contains(x1, y0));
        }
    }


    void check_expand()
    {
        for (int count = 0; count < 100; count++)
        {
            Geda3.Bounds bounds = Geda3.Bounds.with_points(
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
        for (int count = 0; count < 100; count++)
        {
            Geda3.Bounds bounds = Geda3.Bounds();

            assert_true(bounds.empty());

            int x = Test.rand_int_range(0, int.MAX);
            int y = Test.rand_int_range(0, int.MAX);

            bounds.expand(x, y);

            assert_true(bounds.empty());
        }
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/bounds/constructempty", check_construct_empty);
        Test.add_func("/geda/libgeda/bounds/constructwithpoints", check_construct_with_points);
        Test.add_func("/geda/libgeda/bounds/expandempty", check_expand_empty);
        Test.add_func("/geda/libgeda/bounds/expand", check_expand);

        return Test.run();
    }
}
