namespace GedaTest.FillStyle
{
    void check_construct()
    {
        var style = new Geda3.FillStyle();

        assert_true(style.fill_type == Geda3.FillType.HOLLOW);

        assert_true(style.fill_width == Geda3.FillStyle.DEFAULT_WIDTH);

        assert_true(style.fill_angle_1 == Geda3.FillStyle.DEFAULT_ANGLE_1);
        assert_true(style.fill_pitch_1 == Geda3.FillStyle.DEFAULT_PITCH_1);

        assert_true(style.fill_angle_2 == Geda3.FillStyle.DEFAULT_ANGLE_2);
        assert_true(style.fill_pitch_2 == Geda3.FillStyle.DEFAULT_PITCH_2);
    }


    void check_get_set()
    {
        int notify_count = 0;
        var style = new Geda3.FillStyle();

        style.notify.connect(() => { notify_count++; });

        for (var count = 0; count < 100; count++)
        {
            var fill_type = (Geda3.FillType) Test.rand_int_range(
                0,
                Geda3.FillType.COUNT
                );

            var angle_1 = Test.rand_int();
            var pitch_1 = Test.rand_int_range(0, int.MAX);
            var angle_2 = Test.rand_int();
            var pitch_2 = Test.rand_int_range(0, int.MAX);

            notify_count = 0;

            style.fill_type = fill_type;
            assert_true(notify_count == 1);

            style.fill_angle_1 = angle_1;
            assert_true(notify_count == 2);

            style.fill_pitch_1 = pitch_1;
            assert_true(notify_count == 3);

            style.fill_angle_2 = angle_2;
            assert_true(notify_count == 4);

            style.fill_pitch_2 = pitch_2;
            assert_true(notify_count == 5);

            assert_true(style.fill_type == fill_type);
            assert_true(style.fill_angle_1 == angle_1);
            assert_true(style.fill_pitch_1 == pitch_1);
            assert_true(style.fill_angle_2 == angle_2);
            assert_true(style.fill_pitch_2 == pitch_2);
        }
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/fillstyle/construct", check_construct);
        Test.add_func("/geda/libgeda/fillstyle/getset", check_get_set);

        return Test.run();
    }
}
