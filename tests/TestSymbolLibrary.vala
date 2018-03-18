namespace GedaTest.SymbolLibrary
{
    void check_signals()
    {
        var library = new Geda3.SymbolLibrary();

        var use_count = 0;
        var unuse_count = 0;

        library.symbol_used.connect(() => { use_count++; });
        library.symbol_unused.connect(() => { unuse_count++; });

        {
            var symbol = library["symbol_name_0"];

            assert_true(use_count == 1);
            assert_true(unuse_count == 0);
        }

        assert_true(use_count == 1);
        assert_true(unuse_count == 1);

        // two instances of the same symbol should only trigger on use

        use_count = 0;
        unuse_count = 0;

        {
            var symbol0 = library["symbol_name_0"];

            assert_true(use_count == 1);
            assert_true(unuse_count == 0);

            var symbol1 = library["symbol_name_0"];

            assert_true(use_count == 1);
            assert_true(unuse_count == 0);
        }

        assert_true(use_count == 1);
        assert_true(unuse_count == 1);

        // two separate symbols should trigger on use each

        use_count = 0;
        unuse_count = 0;

        {
            var symbol0 = library["symbol_name_0"];

            assert_true(use_count == 1);
            assert_true(unuse_count == 0);

            {
                var symbol1 = library["symbol_name_1"];

                assert_true(use_count == 2);
                assert_true(unuse_count == 0);
            }

            assert_true(use_count == 2);
            assert_true(unuse_count == 1);
        }

        assert_true(use_count == 2);
        assert_true(unuse_count == 2);
    }


    void check_signal_params()
    {
        var library = new Geda3.SymbolLibrary();

        weak Geda3.Symbol created = null;
        string destroyed = "";

        library.symbol_used.connect((symbol) => { created = symbol; });
        library.symbol_unused.connect((name) => { destroyed = name; });

        {
            var symbol = library["symbol_name"];

            assert_true(symbol == created);
        }

        assert_true("symbol_name" == destroyed);
    }


    public static int main(string[] args)
    {
        Test.init(ref args);

        Test.add_func("/geda/libgeda/SymbolLibrary/check_signals", check_signals);
        Test.add_func("/geda/libgeda/SymbolLibrary/check_signal_params", check_signal_params);

        return Test.run();
    }
}
