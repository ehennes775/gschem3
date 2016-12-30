[CCode (cheader_filename = "libgeda/libgeda.h")]
namespace Geda
{
    namespace Angle
    {
        public bool is_normal(int angle);
        public bool is_ortho(int angle);
        public int make_ortho(int angle);
        public int normalize(int angle);
    }
    
    namespace Coord
    {
        public int snap(int coord, int grid);
    }
}

