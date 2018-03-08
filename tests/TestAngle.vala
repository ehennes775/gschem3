namespace GedaTest.Angle
{
    void check_calc_sweep()
    {
        for (var count = 0; count < 1000; count++)
        {
            var a0 = Test.rand_int();
            var a1 = Test.rand_int();

            var sweep = Geda3.Angle.calc_sweep(a0, a1);

            assert_true(sweep > 0);
            assert_true(sweep <= 360);
        }
    }


    void check_convert()
    {
        for (int count = 0; count < 10000; count++)
        {
            int original_angle = Test.rand_int();

            var radians = Geda3.Angle.to_radians(original_angle);
            var calculated_angle = Geda3.Angle.from_radians(radians);

            assert_true(original_angle == calculated_angle);
        }

        assert_true(
            0 == Geda3.Angle.from_radians(0.0)
            );

        assert_true(
            -180 == Geda3.Angle.from_radians(-Math.PI)
            );

        assert_true(
            180 == Geda3.Angle.from_radians(Math.PI)
            );

        assert_true(
            360 == Geda3.Angle.from_radians(2.0 * Math.PI)
            );
    }

    
    void check_is_normal()
    {
        for (int count = 0; count < 10000; count++)
        {
            int angle = Test.rand_int_range(int.MIN, 0);

            assert_true(!Geda3.Angle.is_normal(angle));
        }

        for (int count = 0; count < 10000; count++)
        {
            int angle = Test.rand_int_range(360, int.MAX);

            assert_true(!Geda3.Angle.is_normal(angle));
        }

        for (int count = 0; count < 100; count++)
        {
            int angle = Test.rand_int_range(0, 360);

            assert_true(Geda3.Angle.is_normal(angle));
        }
    }


    void check_is_ortho()
    {
        for (int count = 0; count < 1000000; count++)
        {
            int angle = 90 * Test.rand_int_range(int.MIN / 90, int.MAX / 90);
            int noise = Test.rand_int_range(1, 90);

            assert_true(Geda3.Angle.is_ortho(angle));
            assert_true(!Geda3.Angle.is_ortho(angle + noise));
        }
    }


    void check_normalize()
    {
        for (int count = 0; count < 1000000; count++)
        {
            int angle = Test.rand_int_range(0, 360);
            int noise = 360 * Test.rand_int_range(int.MIN / 360, int.MAX / 360);

            int normalized = Geda3.Angle.normalize(angle + noise);

            assert_true (normalized >= 0);
            assert_true (normalized < 360);
            assert_true (normalized == angle);
        }
    }


    void check_make_ortho()
    {
        for (int count = 0; count < 1000000; count++)
        {
            int angle = 90 * Test.rand_int_range((int.MIN + 45) / 90, int.MAX / 90);
            int noise = Test.rand_int_range(1, 45);

            int normalized = Geda3.Angle.make_ortho(angle + noise);
            assert_true(angle == normalized);

            normalized = Geda3.Angle.make_ortho(angle - noise);
            assert_true(angle == normalized);
        }
    }


    void check_parse()
    {
        for (int count = 0; count < 1000000; count++)
        {
            int input_coord = Test.rand_int();
            int output_coord = Geda3.Coord.parse(input_coord.to_string());

            assert_true(input_coord == output_coord);
        }
    }


    void check_parse_invalid_integer()
    {
        string[] invalid =
        {
            "NotValid",
            "-NotValid",
            "3NotValid"
        };
        
        foreach (var input in invalid)
        {
            try
            {
                try
                {
                    Geda3.Coord.parse(input);
                    assert_not_reached();
                }
                catch (Geda3.ParseError expected)
                {
                    assert_true(expected is Geda3.ParseError.INVALID_INTEGER);
                }
            }
            catch (Error unexpected)
            {
                assert_not_reached();
            }
        }
    }


    void check_parse_out_of_range()
    {
        string[] invalid =
        {
            (int.MAX + 1l).to_string(),
            (int.MIN - 1l).to_string(),
            int64.MAX.to_string(),
            int64.MIN.to_string(),
            "9223372036854775808",         // int64.MAX + 1
            "-9223372036854775809",        // int64.MIN - 1
            "99999999999999999999",
            "-99999999999999999999"
        };
        
        foreach (var input in invalid)
        {
            try
            {
                try
                {
                    Geda3.Coord.parse(input);
                    assert_not_reached();
                }
                catch (Geda3.ParseError expected)
                {
                    assert_true(expected is Geda3.ParseError.OUT_OF_RANGE);
                    stdout.printf("%s\n", expected.message);
                }
            }
            catch (Error unexpected)
            {
                assert_not_reached();
            }
        }
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/angle/calcsweep", check_calc_sweep);
        Test.add_func("/geda/libgeda/angle/convert", check_convert);
        Test.add_func("/geda/libgeda/angle/parse", check_parse);
        Test.add_func("/geda/libgeda/angle/parseinvalidinteger", check_parse_invalid_integer);
        Test.add_func("/geda/libgeda/angle/parseoutofrange", check_parse_out_of_range);
        Test.add_func("/geda/libgeda/angle/isnormal", check_is_normal);
        Test.add_func("/geda/libgeda/angle/isortho", check_is_ortho);
        Test.add_func("/geda/libgeda/angle/makeortho", check_make_ortho);
        Test.add_func("/geda/libgeda/angle/normalize", check_normalize);

        return Test.run();
    }
}
