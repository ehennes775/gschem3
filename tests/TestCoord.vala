namespace GedaTest.Coord
{
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

        Test.add_func("/geda/libgeda/coord/snap", check_snap);

        return Test.run();
    }
}

