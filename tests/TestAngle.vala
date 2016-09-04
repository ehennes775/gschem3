namespace GedaTest.Angle
{
    public static int main(string[] args)
    {
        // these are undefined references until the command line parameters
        // to gcc are reordered. the error occurs during linking

        // this works
        // gcc -g -O2 -o test_angle TestAngle.o -lglib-2.0

        // this does not work
        // gcc -g -O2 -lglib-2.0 -o test_angle TestAngle.o

        // Test.init(ref args);
        // return Test.run();

        return 0;
    }
}
