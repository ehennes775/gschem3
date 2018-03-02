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


    void check_get_set()
    {
        int notify_count = 0;
        var style = new Geda3.LineStyle();

        style.notify.connect(() => { notify_count++; });

        for (var count = 0; count < 100; count++)
        {
            var cap_type = (Geda3.CapType) Test.rand_int_range(
                0,
                Geda3.CapType.COUNT
                );

            var dash_type = (Geda3.DashType) Test.rand_int_range(
                0,
                Geda3.DashType.COUNT
                );

            var dash_length = Test.rand_int_range(0, int.MAX);
            var dash_space = Test.rand_int_range(0, int.MAX);

            notify_count = 0;

            style.cap_type = cap_type;
            assert_true(notify_count == 1);

            style.dash_length = dash_length;
            assert_true(notify_count == 2);

            style.dash_space = dash_space;
            assert_true(notify_count == 3);

            style.dash_type = dash_type;
            assert_true(notify_count == 4);

            assert_true(style.cap_type == cap_type);
            assert_true(style.dash_length == dash_length);
            assert_true(style.dash_space == dash_space);
            assert_true(style.dash_type == dash_type);
        }
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/linestyle/construct", check_construct);
        Test.add_func("/geda/libgeda/linestyle/getset", check_get_set);

        return Test.run();
    }
}
