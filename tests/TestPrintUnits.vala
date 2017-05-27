namespace GedaTest.PrintUnits
{
    void check_parse()
    {
        assert_true(
            Geda3.PrintUnits.IN == Geda3.PrintUnits.parse("in")
            );

        assert_true(
            Geda3.PrintUnits.IN == Geda3.PrintUnits.parse("IN")
            );

        assert_true(
            Geda3.PrintUnits.IN == Geda3.PrintUnits.parse(Geda3.PrintUnits.IN_STRING)
            );

        assert_true(
            Geda3.PrintUnits.MM == Geda3.PrintUnits.parse("mm")
            );

        assert_true(
            Geda3.PrintUnits.MM == Geda3.PrintUnits.parse("MM")
            );

        assert_true(
            Geda3.PrintUnits.MM == Geda3.PrintUnits.parse(Geda3.PrintUnits.MM_STRING)
            );

        try
        {
            Geda3.PrintUnits.parse("ft");
            assert_not_reached();
        }
        catch (Geda3.ParseError expected)
        {
            assert_true(expected is Geda3.ParseError.INVALID_UNITS);
        }
        catch (Error unexpected)
        {
            assert_not_reached();
        }
    }


    void check_string()
    {
        assert_true(
            Geda3.PrintUnits.IN == Geda3.PrintUnits.parse(
                Geda3.PrintUnits.IN.to_string()
                )
            );

        assert_true(
            Geda3.PrintUnits.MM == Geda3.PrintUnits.parse(
                Geda3.PrintUnits.MM.to_string()
                )
            );
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/printunits/parse", check_parse);
        Test.add_func("/geda/libgeda/printunits/string", check_string);

        return Test.run();
    }
}
