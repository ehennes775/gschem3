namespace GedaTest.Coord
{
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


    void check_snap()
    {
        for (int count = 0; count < 1000000; count++)
        {
            int coord = Test.rand_int();
            int snapped = Geda3.Coord.snap(coord, 1);

            assert_true(coord == snapped);
        }

        for (int count = 0; count < 1000000; count++)
        {
            int grid = Test.rand_int_range(4, 10001);
            int coord = grid * Test.rand_int_range((int.MIN + (grid / 2)) / grid, (int.MAX - (grid / 2)) / grid);
            int noise = Test.rand_int_range(1, grid / 2);

            int snapped = Geda3.Coord.snap(coord + noise, grid);
            assert_true(coord == snapped);

            snapped = Geda3.Coord.snap(coord - noise, grid);
            assert_true(coord == snapped);
        }
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/coord/parse", check_parse);
        Test.add_func("/geda/libgeda/coord/parseinvalidinteger", check_parse_invalid_integer);
        Test.add_func("/geda/libgeda/coord/parseoutofrange", check_parse_out_of_range);
        Test.add_func("/geda/libgeda/coord/snap", check_snap);

        return Test.run();
    }
}

