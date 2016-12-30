namespace GedaTest.Coord
{
    void check_snap()
    {
		for (int count = 0; count < 100000; count++)
		{
			int coord = 100 * Test.rand_int_range(int.MIN / 100, int.MAX / 100);
			int noise = Test.rand_int_range(1, 49);
			
			int snapped = Geda.Coord.snap(coord + noise, 100);
			assert_true(coord == snapped);

			snapped = Geda.Coord.snap(coord - noise, 100);
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

