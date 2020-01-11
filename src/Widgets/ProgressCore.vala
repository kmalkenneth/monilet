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

using Cairo;
using Pango;

namespace Monitor {

    public class ProgressCore : Gtk.Bin {
        private int line_width = 6;
        private int radius_pad = 16;

        private Layout layout_porcentage;
        private Layout layout_name;
        private FontDescription description_porcentage;
        private FontDescription description_name;

        private float _progress = 0;
        public float progress {
            get { return _progress;}
            set {
                //stdout.printf("value %.2f \n", value);
                if (value < 0) {
                    _progress = 0;
                } else if (value > 100) {
                    _progress = 100;
                } else {
                    _progress = value;
                }
                queue_draw ();
            }
        }

        public string core_name { get; set; default = "cpu";}

        public ProgressCore (string name) {
            Object (core_name : name);

            /* name tag */
            description_name = new FontDescription ();
            description_name.set_size ((int)(11 * Pango.SCALE));
            description_name.set_weight (Weight.BOLD);

            layout_name = create_pango_layout (core_name);
            layout_name.set_font_description (description_name);
        }

        construct {
            /* porcentage tag */
            description_porcentage = new FontDescription ();
            description_porcentage.set_size ((int)(11 * Pango.SCALE));
            description_porcentage.set_weight (Weight.SEMIBOLD);

            layout_porcentage = create_pango_layout ("%.2f%%".printf (progress));
            layout_porcentage.set_font_description (description_porcentage);
        }

        private int calculate_diameter () {
            int ret = 2 * radius_pad;
            var child = get_child ();
            if (child != null && child.visible) {
                int w, h;
                child.get_preferred_width (out w, null);
                child.get_preferred_height (out h, null);
                ret += (int) Math.sqrt (w * w + h * h);
            }

            return ret;
        }

        public override void get_preferred_width (out int min_w, out int natural_w) {
            var d = calculate_diameter ();
            min_w = d;
            natural_w = d;
        }

        public override void get_preferred_height (out int min_h, out int natural_h) {
            var d = calculate_diameter ();
            min_h = d;
            natural_h = d;
        }

        public override void size_allocate (Gtk.Allocation allocation) {
            base.size_allocate (allocation);
        }

        public override bool draw (Cairo.Context cr) {
            Gtk.Allocation allocation;
            get_allocation (out allocation);
            var center_x = allocation.width / 2;
            var center_y = allocation.height / 2;
            var radius = calculate_diameter () / 2;

            cr.save ();

            cr.set_line_width (line_width);
            cr.set_line_cap (LineCap.ROUND);
            cr.set_line_join (LineJoin.ROUND);

            cr.move_to (radius * 2 + radius * 0.45, center_y + radius * 0.67);

            cr.set_source_rgba (0, 0, 0, 0.3);
            cr.arc (radius * 2, center_y, radius - line_width / 2, 0.75, 5.49);
            cr.stroke ();

            cr.set_source_rgba (0, 0, 0, 0.8);

            int fontw, fonth;
            layout_porcentage.get_pixel_size (out fontw, out fonth);
            cr.move_to (center_x * 1.2 - (fontw / 2), center_y - (fonth * 0.6));

            porcentage_text_update (cr, center_x, center_y);
            cairo_show_layout (cr, layout_porcentage);

            cr.restore ();

            int fontw2, fonth2;
            layout_name.get_pixel_size (out fontw2, out fonth2);
            cr.move_to (center_x * 0.6 - (fontw2 / 2), center_y - (fonth2 * 0.6));

            cairo_update_layout (cr, layout_name);
            cairo_show_layout (cr, layout_name);

            draw_progress (cr, center_x, center_y, radius);

            return base.draw (cr);
        }

        public void draw_progress (Cairo.Context cr, int center_x, int center_y, int radius) {
            porcentage_text_update (cr, center_x, center_y);

            if ( _progress > 0) {
                var porcentage = progress / 100;
                var arc_progress = 0.75 + ((270 * porcentage)/ 180 * Math.PI);

                cr.save ();

                cr.set_line_width (line_width);
                cr.set_line_cap (LineCap.ROUND);
                cr.set_line_join (LineJoin.ROUND);

                cr.move_to (radius * 2 + radius * 0.45, center_y + radius * 0.67);

                cr.set_source_rgba (1, 0.61, 0.57, 1);
                cr.arc (radius * 2, center_y, radius - line_width / 2, 0.75, arc_progress);
                cr.stroke ();

                cr.restore ();
            }
        }

        public void porcentage_text_update (Cairo.Context cr, int center_x, int center_y) {
            layout_porcentage.set_text ("%.2f%%".printf (_progress), -1);

            int fontw, fonth;
            layout_porcentage.get_pixel_size (out fontw, out fonth);
            cr.move_to (center_x * 1.2 - (fontw / 2), center_y - (fonth * 0.6));

            cairo_update_layout (cr, layout_porcentage);
        }
    }
}
