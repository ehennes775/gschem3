namespace GedaTest.ColorScheme
{
    void check_empty()
    {
        var scheme = new Geda3.ColorScheme();

        for (int count = 0; count < 1000; count++)
        {
            var index = Test.rand_int_range(1, int.MAX);

            var color = scheme[index];

            assert_true(color.red == 1.0);
            assert_true(color.blue == 1.0);
            assert_true(color.green == 1.0);
            assert_true(color.alpha == 1.0);
        }
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/gschem3/colorscheme/checkempty", check_empty);

        return Test.run();
    }
}

