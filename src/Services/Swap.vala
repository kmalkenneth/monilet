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
    public class Swap : GLib.Object {
        private float _percentage_used;
        private float _total;
        private float _used;

        public float percentage_used {
            get { update_percentage_used (); return _percentage_used; }
        }
        public float total {
            get { update_total (); return _total; }
        }
        public float used {
            get { update_used (); return _used; }
        }

        public Swap () {
            this._percentage_used = 0;
            this._used = 0;
            this._total = 0;
        }

        private void update_percentage_used () {
            _percentage_used = ((used / total) * 100);
        }

        private void update_total () {
            GTop.Swap swap;
            GTop.get_swap (out swap);
            _total = (((float) swap.total / 1024) / 1024) / 1024;
        }

        private void update_used () {
            GTop.Swap swap;
            GTop.get_swap (out swap);
            _used = (((float) swap.used / 1024) / 1024) / 1024;
        }
    }
}
