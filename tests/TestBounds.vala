namespace GedaTest.Angle
{
    void check_construct_empty()
    {
        Geda3.Bounds bounds = Geda3.Bounds();

        assert_true(bounds.empty());
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/bounds/constructempty", check_construct_empty);

        return Test.run();
    }
}
