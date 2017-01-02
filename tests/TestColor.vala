namespace GedaTest.Color
{
    void check_parse()
    {
        for (int count = 0; count < 1000000; count++)
        {
            int input_color = Test.rand_int_range(0, int.MAX);
            int output_color = Geda3.Color.parse(input_color.to_string());

            assert_true(input_color == output_color);
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
                    Geda3.Color.parse(input);
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
            "-1",
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
                    Geda3.Color.parse(input);
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

        Test.add_func("/geda/libgeda/color/parse", check_parse);
        Test.add_func("/geda/libgeda/color/parseinvalidinteger", check_parse_invalid_integer);
        Test.add_func("/geda/libgeda/color/parseoutofrange", check_parse_out_of_range);

        return Test.run();
    }
}

