using Cairo;
using Pango;
using Math;

namespace monilet {

    public class WidgetMemory : Gtk.Bin {
        int line_width = 6;
        int radius_pad = 64;
        
        Layout layout_porcentage;
        Layout layout_name;
        FontDescription description_porcentage;
        FontDescription description_name;
        
        UtilsWidget util;
        
        public  float used { get; set; default = 0;}
        public  float total { get; set; default = 0;}
        int _progress = 0;
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
            util = new UtilsWidget ();
        
            /* porcentage tag */
            description_porcentage = new FontDescription();
            description_porcentage.set_size ((int)(18 * Pango.SCALE));
            description_porcentage.set_weight (Weight.BOLD);
            
            layout_porcentage = create_pango_layout ("%d%%".printf(progress));
            layout_porcentage.set_font_description (description_porcentage);
                        
            /* name tag */
            description_name = new FontDescription();
            description_name.set_size ((int)(10 * Pango.SCALE));
            description_name.set_weight (Weight.SEMIBOLD);
            
            layout_name = create_pango_layout ("Memory");
            layout_name.set_font_description (description_name);
        }
        
        public override bool draw (Cairo.Context cr) {
            Gtk.Allocation allocation;
            get_allocation (out allocation);
            var center_x = allocation.width / 2;
            var center_y = allocation.height / 2;
            var radius = calculate_diameter () / 2;

            draw_arc (cr, center_x, center_y, radius);
                      
            draw_used (cr, center_x, center_y, radius);
                      
            draw_numbers (cr, center_x, center_y, radius);          

            cr.save ();

            cr.set_source_rgba (0.94, 0.95, 0.97, 1);

            float x, y;
            int fontw, fonth;

            util.get_point_circuference ( 12, 90, (float) center_x, (float) center_y, out x, out y);
            layout_porcentage.get_pixel_size (out fontw, out fonth);
            
            cr.move_to (x - (fontw / 2), y - (fonth / 2));
            
            porcentage_text_update (cr, center_x, center_y);            
            cairo_show_layout (cr, layout_porcentage);

            cr.set_source_rgba (0.55, 0.56, 0.60, 1);

            layout_name.get_pixel_size (out fontw, out fonth);
            util.get_point_circuference ( 12, 270, (float) center_x, (float) center_y, out x, out y);

            cr.move_to (x - (fontw / 2), y - (fonth / 2));
            
            cairo_update_layout (cr, layout_name);
            cairo_show_layout (cr, layout_name);
            
            cr.restore ();
            
            draw_progress (cr, center_x, center_y, radius);

            return base.draw (cr);
        }
        
        private void draw_arc (Cairo.Context cr, double center_x, double center_y, float radius){
            cr.save ();
            
            cr.set_line_width (line_width / 2);
            cr.set_line_cap (LineCap.ROUND);
            cr.set_line_join (LineJoin.ROUND);
            
            float x, y;
            util.get_point_circuference (radius - line_width / 2, 225, (float) center_x, (float) center_y, out x, out y);

            cr.move_to (x, y);

            cr.set_source_rgba (util.get_rgb_gtk (63), util.get_rgb_gtk (91), util.get_rgb_gtk (94), 1);
            cr.arc (center_x, center_y, radius - line_width / 2, util.get_radians (135), util.get_radians (45));
            cr.stroke ();
            
            cr.restore ();
        }
        
        private void draw_used (Cairo.Context cr, double center_x, double center_y, float radius){
            cr.save ();
            
            cr.set_line_width (line_width / 2);
            cr.set_line_cap (LineCap.ROUND);
            cr.set_line_join (LineJoin.ROUND);
            
            float x, y;
            util.get_point_circuference (radius - line_width * 1.5f, 270, (float) center_x, (float) center_y, out x, out y);

            cr.move_to (x, y);
            
            cr.set_source_rgba (util.get_rgb_gtk (205), util.get_rgb_gtk (208), util.get_rgb_gtk (213), 1);
            
            /* core tag */
            var description = new FontDescription();
            description.set_size ((int)(10 * Pango.SCALE));
            description.set_weight (Weight.NORMAL);
            
            var layout = create_pango_layout ("%.1f %s / %.1f %s".printf(used, _("GiB"), total, _("GiB")));
            layout.set_font_description (description);
            
            int fontw, fonth;
            layout.get_pixel_size (out fontw, out fonth);
            cr.move_to (x - fontw / 2, y - fonth / 2);
            
            cairo_update_layout (cr, layout);
            cairo_show_layout (cr, layout);
            
            cr.restore ();
        }
        
        private void draw_numbers (Cairo.Context cr, double center_x, double center_y, float radius){
            cr.save ();
            
            cr.set_line_width (line_width / 2);
            cr.set_line_cap (LineCap.ROUND);
            cr.set_line_join (LineJoin.ROUND);
            
            float x, y;
            
            for (int i = 0; i <= 10; i++){
                var position = 10 * i;
                var porcentage = (float) position / 100;
                var preprogress = 225 - 270 * porcentage;
                var arc_progress = 0f;
                if (preprogress < 0) {
                    arc_progress = 360 - preprogress.abs();
                } else {
                    arc_progress = preprogress;
                }

                util.get_point_circuference (radius - line_width * 2.75f, arc_progress, (float) center_x, (float) center_y, out x, out y);
                          
                cr.set_source_rgba (util.get_rgb_gtk (205), util.get_rgb_gtk (208), util.get_rgb_gtk (213), 1);
                
                /* core tag */
                var description = new FontDescription();
                description.set_size ((int)(7 * Pango.SCALE));
                description.set_weight (Weight.NORMAL);
                
                var layout = create_pango_layout ("%d".printf(position));
                layout.set_font_description (description);
                
                int fontw, fonth;
                layout.get_pixel_size (out fontw, out fonth);
                cr.move_to (x - fontw / 2, y - fonth / 2);
                
                cairo_update_layout (cr, layout);
                cairo_show_layout (cr, layout);
            }
            
            cr.restore ();
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
                util.get_point_circuference (radius - line_width / 2, 225, (float) center_x, (float) center_y, out x, out y);
    
                cr.move_to (x, y);
    
                cr.set_source_rgba (util.get_rgb_gtk (91), util.get_rgb_gtk (218), util.get_rgb_gtk (188), 1);
                cr.arc (center_x, center_y, radius - line_width / 2, util.get_radians (135), util.get_radians (arc_progress));
                cr.stroke ();
                
                cr.restore ();
            }
        }
            
        public void porcentage_text_update (Cairo.Context cr, int center_x, int center_y){
            layout_porcentage.set_text ("%d".printf(_progress), -1);
            
            float x, y;
            int fontw, fonth;
 
            util.get_point_circuference ( 12, 90, (float) center_x, (float) center_y, out x, out y);
            layout_porcentage.get_pixel_size (out fontw, out fonth);

            cr.move_to (x - (fontw / 2), y - (fonth / 2));
            
            cairo_update_layout (cr, layout_porcentage);
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
    }
}
