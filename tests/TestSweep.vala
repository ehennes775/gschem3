namespace GedaTest.Sweep
{
    void check_from_angles()
    {
        for (var count = 0; count < 1000; count++)
        {
            var start = Test.rand_int_range(int.MIN, int.MAX - 359);
            var sweep0 = Test.rand_int_range(1, 361);

            var sweep1 = Geda3.Sweep.from_angles(start, start + sweep0);

            assert_true(sweep1 > 0);
            assert_true(sweep1 <= 360);
            assert_true(sweep0 == sweep1);
        }


        for (var count = 0; count < 1000; count++)
        {
            var start = Test.rand_int();
            var sweep = Geda3.Sweep.from_angles(start, start);

            assert_true(sweep == 360);
        }
    }


    void check_is_normal()
    {
        for (var count = 0; count < 10000; count++)
        {
            var sweep = Test.rand_int_range(int.MIN, -360);

            assert_true(!Geda3.Sweep.is_normal(sweep));
        }

        for (var count = 0; count < 10000; count++)
        {
            var sweep = Test.rand_int_range(361, int.MAX);

            assert_true(!Geda3.Sweep.is_normal(sweep));
        }

        for (var count = 0; count < 100; count++)
        {
            var sweep = Test.rand_int_range(-360, 361);

            assert_true(Geda3.Sweep.is_normal(sweep));
        }
    }


    void check_normalize()
    {
        for (var count = 0; count < 10000; count++)
        {
            var sweep = Test.rand_int_range(int.MIN, -360);

            assert_true(-360 == Geda3.Sweep.normalize(sweep));
        }

        for (var count = 0; count < 10000; count++)
        {
            var sweep = Test.rand_int_range(361, int.MAX);

            assert_true(360 == Geda3.Sweep.normalize(sweep));
        }

        for (var count = 0; count < 100; count++)
        {
            var sweep = Test.rand_int_range(-360, 361);

            assert_true(sweep == Geda3.Sweep.normalize(sweep));
        }
    }


    void check_reverse()
    {
        for (int count = 0; count < 100; count++)
        {
            var original_sweep = (int) Test.rand_int_range(-359, 0);
            var reverse_sweep = Geda3.Sweep.reverse(original_sweep);

            assert_true(360 == original_sweep.abs() + reverse_sweep);
        }

        for (int count = 0; count < 100; count++)
        {
            var original_sweep = Test.rand_int_range(1, 360);
            var reverse_sweep = Geda3.Sweep.reverse(original_sweep);

            assert_true(360 == original_sweep + reverse_sweep.abs());
        }

        assert_true(
            360 == Geda3.Sweep.reverse(0)
            );

        assert_true(
            -360 == Geda3.Sweep.reverse(360)
            );

        assert_true(
            360 == Geda3.Sweep.reverse(-360)
            );
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/sweep/from_angles", check_from_angles);
        Test.add_func("/geda/libgeda/sweep/isnormal", check_is_normal);
        Test.add_func("/geda/libgeda/sweep/normalize", check_normalize);
        Test.add_func("/geda/libgeda/sweep/reverse", check_reverse);

        return Test.run();
    }
}
