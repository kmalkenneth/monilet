/*  
*   Copyright (c) 2017-2020 kmal-kenneth (https://github.com/kmal-kenneth)
*
*   This file is part of Monilet.
*
*   Monilet is free software: you can redistribute it and/or modify
*   it under the terms of the GNU General Public License as published by
*   the Free Software Foundation, either version 3 of the License, or
*   (at your option) any later version.
*
*   Monilet is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with Monilet.  If not, see <https://www.gnu.org/licenses/>.  
*
*   Authored by: Kenet Mauricio Acuña Lago <kmal.kenneth@live.com>
*/

namespace Monitor {
    public class UnitFormat : Object {
        public string format_size_values (uint64 value) {
            if (value >= 1000000000000)
                return "%.3f TB".printf ((double) value / 1000000000000d);
            else if (value >= 1000000000)
                return "%.1f GB".printf ((double) value / 1000000000d);
            else if (value >= 1000000)
                return (value / 1000000).to_string () + " MB";
            else if (value >= 1000)
                return (value / 1000).to_string () + " KB";
            else
                return value.to_string () + " B";
        }

        public string format_size_speed_values (uint64 value) {
            if (value >= 1000000000000)
                return "%.3f TB/s".printf ((double) value / 1000000000000d);
            else if (value >= 1000000000)
                return "%.1f GB/s".printf ((double) value / 1000000000d);
            else if (value >= 1000000)
                return "%.2f MB/s".printf ((double) value / 1000000d);
            else if (value >= 1000)
                return (value / 1000).to_string () + " KB/s";
            else
                return value.to_string () + " B/s";
        }
    }
}
