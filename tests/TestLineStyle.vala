namespace GedaTest.LineStyle
{
    void check_construct()
    {
        var style = new Geda3.LineStyle();

        assert_true(style.cap_type == Geda3.CapType.NONE);

        assert_true(style.dash_length == Geda3.DashType.DEFAULT_LENGTH);
        assert_true(style.dash_space == Geda3.DashType.DEFAULT_SPACE);
        assert_true(style.dash_type == Geda3.DashType.SOLID);
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/bounds/construct", check_construct);

        return Test.run();
    }
}
