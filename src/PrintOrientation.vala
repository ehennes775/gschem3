/*
 *  Copyright (C) 2012 Edward Hennessy
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU General Public License
 *  as published by the Free Software Foundation; either version 2
 *  of the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
namespace Geda3
{
    /**
     * Paper orientations supported by the lepton-cli utility
     */
    public enum PrintOrientation
    {
        /**
         * Automatically select between portrait and landscape
         */
        AUTO,


        /**
         * Longest paper length across the top
         */
        LANDSCAPE,


        /**
         * Shortest paper length across the top
         */
        PORTRAIT,


        /**
         * The number of options for print orientation
         */
        COUNT;


        /**
         * The string name for the auto enumeration value
         *
         * This string is compatible with the command line arguments
         * for the lepton-cli utility.
         */
        private static const string AUTO_NAME = "auto";


        /**
         * The string name for the landscape enumeration value
         *
         * This string is compatible with the command line arguments
         * for the lepton-cli utility.
         */
        private static const string LANDSCAPE_NAME = "landscape";


        /**
         * The string name for the portrait enumeration value
         *
         * This string is compatible with the command line arguments
         * for the lepton-cli utility.
         */
        private static const string PORTRAIT_NAME = "portrait";


        /**
         * Parse a string containing a paper orientation
         *
         * @param [in] str The string containing the paper orientation
         * @param [out] orientation The paper orientation value
         * @return true Parsing successful, orientation contains the value
         * @return false Parsing unsuccessful
         */
        public static bool try_parse(string str, out PrintOrientation orientation)
        {
            switch (str)
            {
                case AUTO_NAME:
                    orientation = AUTO;
                    return true;

                case LANDSCAPE_NAME:
                    orientation = LANDSCAPE;
                    return true;

                case PORTRAIT_NAME:
                    orientation = PORTRAIT;
                    return true;

                default:
                    /* assignment removes unused parameter warning */
                    orientation = AUTO;
                    return false;
            }
        }


        /**
         * Convert the paper orientation to a string
         *
         * The string returned is compatible with the command line
         * arguments of the lepton-cli utility.
         *
         * @return A string containing the paper orientation
         */
        public string to_string()
        {
            switch (this)
            {
                case AUTO:
                    return AUTO_NAME;

                case LANDSCAPE:
                    return LANDSCAPE_NAME;

                case PORTRAIT:
                    return PORTRAIT_NAME;

                default:
                    warn_if_reached();
                    return AUTO_NAME;
            }
        }
    }
}
