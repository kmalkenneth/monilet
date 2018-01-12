/*
* Copyright (c) 2017-2017 kaml-kenneth (https://github.com/kmal-kenneth)
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Authored by: Kenet Mauricio Acuña Lago <kmal.kenneth@live.com>
*/

namespace monilet {

    public class MainWindow : Gtk.Dialog {
        // application reference
        //private Application app;

        // Widgets
        //private Gtk.HeaderBar header;
        private WidgetCpu widget_cpu;
        private CPU cpu;

        public MainWindow (Application app) {
            Object (application: app,
                    resizable: false,
                    title: _("Nimbus"),
                    height_request: 272,
                    width_request: 500);
            //this.app = app;
            //this.set_application (this.app);
            //this.set_default_size (880, 720);
            this.window_position = Gtk.WindowPosition.CENTER;
            //this.get_style_context ().add_class ("rounded");
            
            widget_cpu.cores = cpu.quantity_cores;
            update ();
            
            //progress_cpu.progress = 70;
        }
        
        construct {
            get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
            
            cpu = new CPU ();
            widget_cpu = new WidgetCpu ();
            //set_keep_below (true);
            //stick ();
            
            var content_box = get_content_area () as Gtk.Box;
            content_box.border_width = 0;
            content_box.add (widget_cpu);
            content_box.show_all ();
        }
        
        private void update () {
    	    Timeout.add_seconds (1, () => {
    	        widget_cpu.progress = cpu.percentage_used;
               return true;
           });
    	}

         private void setup_ui () {
            // setup header bar
            //header = new Gtk.HeaderBar ();
            //header.show_close_button = true;
            //header.get_style_context ().add_class ("default-decoration");
            //header.title = _("Monitor");
            //header.subtitle = _("A litle system monitor");

            //add (layout);
            //this.set_titlebar (header);
        }

    }
}

