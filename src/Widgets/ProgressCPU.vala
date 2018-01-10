using Cairo;
using Pango;
using Math;

namespace monilet {

    public class ProgressCPU : Gtk.Bin {
        private int line_width = 6;
        private int radius_pad = 64;
        
        private Layout layout_porcentage;
        private Layout layout_name;
        private FontDescription description_porcentage;
        private FontDescription description_name;
        
        private  int _progress = 0;
        public int progress {
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
            description_porcentage.set_size ((int)(20 * Pango.SCALE));
            description_porcentage.set_weight (Weight.SEMIBOLD);
            
            layout_porcentage = create_pango_layout ("%d%%".printf(progress));
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

            draw_arc (cr, center_x, center_y, radius);          

            cr.save ();

            cr.set_source_rgba (0.94, 0.95, 0.97, 1);

            int fontw, fonth;
            layout_porcentage.get_pixel_size (out fontw, out fonth);
            cr.move_to (center_x - (fontw / 2), center_y - (fonth / 2));
            
            porcentage_text_update (cr, center_x, center_y);            
            cairo_show_layout (cr, layout_porcentage);

            cr.set_source_rgba (0.55, 0.56, 0.60, 1);
            int fontw2, fonth2;
            layout_name.get_pixel_size (out fontw2, out fonth2);
            cr.move_to (center_x - (fontw2 / 2), center_y + (radius/2));
            
            cairo_update_layout (cr, layout_name);
            cairo_show_layout (cr, layout_name);
            
            cr.restore ();
            
            draw_progress (cr, center_x, center_y, radius);

            return base.draw (cr);
        }

        public void draw_progress (Cairo.Context cr, int center_x, int center_y, int radius) {
            porcentage_text_update (cr, center_x, center_y);
            
            if ( _progress > 0) {
                //var arc_progress = 2.35 + ((270 * porcentage)/ 180 * Math.PI);
                var porcentage = (float) progress / 100;
                var preprogress = 270 * porcentage + 135;
                var arc_progress = 0;
                if (preprogress > 360) {
                    arc_progress = (int) Math.round(preprogress.abs() - 360);
                } else {
                    arc_progress = (int) Math.round(preprogress);
                }
                //stdout.printf("value %.2f \n", arc_progress);
                
                cr.save ();
                
                cr.set_line_width (line_width);
                cr.set_line_cap (LineCap.ROUND);
                cr.set_line_join (LineJoin.ROUND);
                
                float x, y;
                get_point_circuferens (radius - line_width / 2, 225, (float) center_x, (float) center_y, out x, out y);
    
                cr.move_to (x, y);
    
                cr.set_source_rgba (convert_rgb_gtk (91), convert_rgb_gtk (218), convert_rgb_gtk (188), 1);
                cr.arc (center_x, center_y, radius - line_width / 2, convert_radians (135), convert_radians (arc_progress));
                cr.stroke ();
                
                cr.restore ();
            }
        }
            
        public void porcentage_text_update (Cairo.Context cr, int center_x, int center_y){
            layout_porcentage.set_text ("%d%%".printf(_progress), -1);
            
            int fontw, fonth;
            layout_porcentage.get_pixel_size (out fontw, out fonth);
            cr.move_to (center_x - (fontw / 2), center_y - (fonth / 2));
            
            cairo_update_layout (cr, layout_porcentage);
        }
        
        private void get_point_circuferens (float radius, double angle, float x_center, double y_center, out float x, out float y) {
            x = 0;
            y = 0;
            
            var j = calc_x (radius, angle);
            var k = calc_y (radius, angle);
            
            if (angle == 0) {
                x = (float) x_center + radius;
                y = (float) y_center;
            } else if (angle == 90){
                x = (float) x_center;
                y = (float) y_center - radius;
            } else if (angle == 180){
                x = (float) x_center - radius;
                y = (float) y_center;
            } else if (angle == 270){
                x = (float) x_center;
                y = (float) y_center + radius;
            } else if (angle == 360){
                x = (float) x_center + radius;
                y = (float) y_center;
            } else {
                if (angle > 0 && angle < 90){
                    x = (float) x_center + j.abs ();
                    y = (float) y_center - k.abs ();
                } else if (angle > 90 && angle < 180){
                    x = (float) x_center - j.abs ();
                    y = (float) y_center - k.abs ();
                }  else if (angle > 180 && angle < 270){
                    x = (float) x_center - j.abs ();
                    y = (float) y_center + k.abs ();
                } else if (angle > 270 && angle < 360){
                    x = (float) x_center + j.abs ();
                    y = (float) y_center + k.abs ();
                }  
            }
            //stdout.printf("radio %.2f angle %.2f x-center %.2f x %.2f y-center %.2f y %.2f\n", radius, angle, x_center, x, y_center, y);
        }
        
        private float calc_x (float radius, double angle){
            return (float) (radius * cos (convert_radians (angle)));
        }
        
        private float calc_y (float radius, double angle){
            return (float) (radius * sin (convert_radians (angle)));
        }
        
        private double convert_radians (double grades) {
            return grades / 180 * Math.PI;
        }
        
        private float convert_rgb_gtk (int color) {
            return (float) color / 225;
        }
        
        private void draw_arc (Cairo.Context cr, double center_x, double center_y, float radius){
            cr.save ();
            
            cr.set_line_width (line_width / 2);
            cr.set_line_cap (LineCap.ROUND);
            cr.set_line_join (LineJoin.ROUND);
            
            float x, y;
            get_point_circuferens (radius - line_width / 2, 225, (float) center_x, (float) center_y, out x, out y);

            cr.move_to (x, y);

            cr.set_source_rgba (convert_rgb_gtk (63), convert_rgb_gtk (91), convert_rgb_gtk (94), 1);
            cr.arc (center_x, center_y, radius - line_width / 2, convert_radians (135), convert_radians (45));
            cr.stroke ();
            
            cr.restore ();
        }
    }
}
