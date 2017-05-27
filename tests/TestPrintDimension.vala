namespace GedaTest.PrintDimension
{
    void check_parse_in()
    {
        var dim_in = new Geda3.PrintDimension(0.5, Geda3.PrintUnits.IN);

        assert_true(0.5 == dim_in.number);
        assert_true(Geda3.PrintUnits.IN == dim_in.units);

        string[] str_in = {
            "0.5 in",
            " 0.5 in",
            "0.5 in ",
            "0.5in",
            "0.5  in",
            "0.5 IN",
            " 0.5 IN",
            "0.5 IN ",
            "0.5IN",
            "0.5  IN"
            };

        foreach (var str in str_in)
        {
            var dim = Geda3.PrintDimension.parse(str);

            assert_true(dim.number == dim_in.number);
            assert(dim.units == dim_in.units);
        }
    }


    void check_parse_mm()
    {
        var dim_mm = new Geda3.PrintDimension(10.0, Geda3.PrintUnits.MM);

        assert_true(10.0 == dim_mm.number);
        assert_true(Geda3.PrintUnits.MM == dim_mm.units);

        string[] str_mm = {
            "10 mm",
            " 10 mm",
            "10 mm ",
            "10mm",
            "10  mm",
            "10 MM",
            " 10 MM",
            "10 MM ",
            "10MM",
            "10  MM"
            };

        foreach (var str in str_mm)
        {
            var dim = Geda3.PrintDimension.parse(str);

            assert_true(dim.number == dim_mm.number);
            assert(dim.units == dim_mm.units);
        }
    }


    void check_parse_invalid()
    {
        string[] str_invalid = {
            "",
            " ",
            "miles",
            "10 miles",
            "10.0 m",
            "10.0 i",
            "1E+3 mm"
            };

        foreach (var str in str_invalid)
        {
            try
            {
                Geda3.PrintUnits.parse(str);
                assert_not_reached();
            }
            catch (Geda3.ParseError expected)
            {
                assert_true(expected is Geda3.ParseError.INVALID_UNITS);
            }
            catch (Error unexpected)
            {
                Test.message(unexpected.message);
                Test.fail();
            }
        }
    }


    void check_string()
    {
        try
        {
            for (var count = 0; count < 10000; count++)
            {
                var number = Test.rand_double();
                var units = (Geda3.PrintUnits) Test.rand_int_range(0, Geda3.PrintUnits.COUNT);

                var original_dim = new Geda3.PrintDimension(number, units);
                var original_str = original_dim.to_string();

                stdout.printf("original dimension = '%s'\n", original_str);

                var duplicate_dim = Geda3.PrintDimension.parse(original_str);
                var duplicate_str = duplicate_dim.to_string();

                assert(original_str == duplicate_str);
            }
        }
        catch (Error unexpected)
        {
            Test.message(unexpected.message);
            Test.fail();
        }
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/printunits/parsein", check_parse_in);
        Test.add_func("/geda/libgeda/printunits/parsemm", check_parse_mm);
        Test.add_func("/geda/libgeda/printunits/parseinvalid", check_parse_invalid);
        Test.add_func("/geda/libgeda/printunits/string", check_string);

        return Test.run();
    }
}
