using Cairo;
using Pango;

namespace monitor {

    public class ProgressCPU : Gtk.Bin {
        private int line_width = 6;
        private int radius_pad = 64;
        
        private Layout layout_porcentage;
        private Layout layout_name;
        private FontDescription description_porcentage;
        private FontDescription description_name;
        
        private  float _progress = 0;
        public float progress {
            get { return _progress;}
            set { 
                //stdout.printf("value %.2f \n", value);
                if (value < 0){
                    _progress = 0;                
                } else if (value > 100) {
                    _progress = 100;                
                } else {
                    _progress = value;                
                }
                queue_draw (); 
            }
        }
        
        construct {
            /* porcentage tag */
            description_porcentage = new FontDescription();
            description_porcentage.set_size ((int)(18 * Pango.SCALE));
            description_porcentage.set_weight (Weight.SEMIBOLD);
            
            layout_porcentage = create_pango_layout ("%.2f%%".printf(progress));
            layout_porcentage.set_font_description (description_porcentage);
                        
            /* name tag */
            description_name = new FontDescription();
            description_name.set_size ((int)(20 * Pango.SCALE));
            description_name.set_weight (Weight.BOLD);
            
            layout_name = create_pango_layout ("CPU");
            layout_name.set_font_description (description_name);
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

            cr.move_to (center_x - radius * 0.67, center_y + radius * 0.67);

            cr.set_source_rgba (0, 0, 0, 0.3);
            cr.arc (center_x, center_y, radius - line_width / 2, 2.35, 0.78);
            cr.stroke ();

            cr.set_source_rgba (0, 0, 0, 0.8);

            int fontw, fonth;
            layout_porcentage.get_pixel_size (out fontw, out fonth);
            cr.move_to (center_x - (fontw / 2), center_y - (fonth / 2));
            
            porcentage_text_update (cr, center_x, center_y);            
            cairo_show_layout (cr, layout_porcentage);

            cr.restore ();
            
            int fontw2, fonth2;
            layout_name.get_pixel_size (out fontw2, out fonth2);
            cr.move_to (center_x - (fontw2 / 2), center_y + (radius/2));
            
            cairo_update_layout (cr, layout_name);
            cairo_show_layout (cr, layout_name);
            
            draw_progress (cr, center_x, center_y, radius);

            return base.draw (cr);
        }

        public void draw_progress (Cairo.Context cr, int center_x, int center_y, int radius) {
            porcentage_text_update (cr, center_x, center_y);
            
            if ( _progress > 0) {
                var porcentage = progress / 100;
                var arc_progress = 2.35 + ((270 * porcentage)/ 180 * Math.PI);
                
                cr.save ();
                
                cr.set_line_width (line_width);
                cr.set_line_cap (LineCap.ROUND);
                cr.set_line_join (LineJoin.ROUND);
                
                cr.move_to (center_x - radius * 0.67, center_y + radius * 0.67);
    	
                cr.set_source_rgba (0.54, 0.83, 1, 1);
                cr.arc (center_x, center_y, radius - line_width / 2, 2.35, arc_progress);
                cr.stroke ();

                cr.restore ();
            }
        }
            
        public void porcentage_text_update (Cairo.Context cr, int center_x, int center_y){
            layout_porcentage.set_text ("%.2f%%".printf(_progress), -1);
            
            int fontw, fonth;
            layout_porcentage.get_pixel_size (out fontw, out fonth);
            cr.move_to (center_x - (fontw / 2), center_y - (fonth / 2));
            
            cairo_update_layout (cr, layout_porcentage);
        }
    }
}
