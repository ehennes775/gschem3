namespace GedaTest.Angle
{
    void check_construct_empty()
    {
        Geda3.Bounds bounds = Geda3.Bounds();

        assert_true(bounds.empty());
    }

    void check_construct_with_points()
    {
        for (int count = 0; count < 100; count++)
        {
            Geda3.Bounds bounds = Geda3.Bounds.with_points(
                Test.rand_int(),
                Test.rand_int(),
                Test.rand_int(),
                Test.rand_int()
                );

            assert_true(!bounds.empty());
        }
    }

    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/bounds/constructempty", check_construct_empty);
        Test.add_func("/geda/libgeda/bounds/constructwithpoints", check_construct_with_points);

        return Test.run();
    }
}
